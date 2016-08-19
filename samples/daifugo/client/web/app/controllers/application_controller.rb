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
          return account
        else
          login.login = false
          login.save
        end
      end

      login = Session.new(account_id: account.id, session_id: session[:session_id], login_at: Time.now, expire_at: Time.now + 5 * 60).save
      settings.sockets.each {|ws| ws.send("login: #{account.name} is logged in.")}
      account
    else
      raise "Login failed"
    end
  end
end
