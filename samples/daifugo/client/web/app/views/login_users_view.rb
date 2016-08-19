require_relative '../models/account'
require_relative '../models/session'
require_relative 'player_view'

class LoginUsersView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def initial_state
    PushMessage.default.on_receive(:login) {|cmd, msg| puts msg; fetch_login_users }
    fetch_login_users
    { login_users: [] }
  end

  def fetch_login_users
    Session.login_users do |status, res|
      if status == :success
        puts res.inspect
        login_users = res.json.map{|v| Session.new(v) }
        set_state(login_users: login_users)
      end
    end
  end

  def render
    ul({class: 'login-users'}, @state[:login_users].map {|user| li(nil, PlayerView.el(player:user.account)) })
  end
end
