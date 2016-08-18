class ApplicationController < Menilite::Controller
  before_action(expect: ["ApplicationController#login", "Player#signup"]) do
    raise "Authorization failure" unless Session.auth(session[:session_id])
  end

  action :login do |username, password|
    player = Player.fetch(filter: {login: username}).first

    if player && player.auth(password)
      login =  Session.fetch(filter:{player_id: player.id, login: true}).first
      if login
        if login.session_id == session[:session_id]
          login.expire_at = Time.now + 5 * 60
          login.save
          return player
        else
          login.login = false
          login.save
        end
      end

      login = Session.new(player_id: player.id, session_id: session[:session_id], login_at: Time.now, expire_at: Time.now + 5 * 60).save
      settings.sockets.each {|ws| ws.send("login: #{player.name} is logged in.")}
      player
    else
      raise "Login failed"
    end
  end
end
