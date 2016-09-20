class ApplicationController < Menilite::Controller
  before_action(expect: ["ApplicationController#login", "Account#signup"]) do
    raise "Authorization failure" unless Session.auth(session[:session_id])
  end

  action :login do |username, password|
    account = Account.fetch(filter: {uid: username}).first

    if account && account.auth(password)
      login =  Session.fetch(filter:{account_id: account.id, login: true}).first
      if login
        if login.session_id == session[:session_id]
          login.expire_at = Time.now + 5 * 60
          login.save
          return account.to_h
        else
          login.login = false
          login.save
        end
      end

      login = Session.new(account_id: account.id, session_id: session[:session_id], login_at: Time.now, expire_at: Time.now + 5 * 60).save
      settings.sockets.values.flatten.each {|ws| ws.send("login: #{account.name} is logged in.")}
      account
    else
      raise "Login failed"
    end
  end

  action :board_state do
    session = Session.find(session_id: self.session[:session_id], login: true)
    player = Player.find(account_id: session.account_id, playing: true)
    opponents = Player.fetch(filter: {game_id: player.game_id, playing: true}).reject{|p| p.id == player.id }.map{|p| p.account.to_h }

    { account: session.account.to_h, opponents: opponents }
  end
end
