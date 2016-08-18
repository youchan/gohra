class ApplicationController < Menilite::Controller
  before_action(expect: ["ApplicationController#login", "Player#signup"]) do
    login = session[:login]
    if login && login.expire_at > Time.now
      login.expire_at = Time.now + 5 * 60
      login.save
    else
      login.login = false if login
      raise "Authorization failure"
    end
  end

  action :login do |username, password|
    player = Player.fetch(filter: {login: username}).first

    if player && player.auth(password)
      login =  Session.fetch(filter:{player_id: player.id, login: true}).first
      if login
        if login.session_id == session[:session_id]
          session[:login] = login
          login.expire_at = Time.now + 5 * 60
          login.save
          return player
        else
          if login.expire_at > Time.now
            login.login = false
            login.save
          else
            raise "Already logged-in"
          end
        end
      end

      session[:login] = Session.new(player_id: player.id, session_id: session[:session_id], login_at: Time.now, expire_at: Time.now + 5 * 60).save
      settings.sockets.each {|ws| ws.send("login: #{player.name} is logged in.")}
      player
    else
      raise "Login failed"
    end
  end
end
