require_relative 'login_users_view'

class LobbyView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def render
    div({className: 'lobby'},
      LoginUsersView.el
    )
  end
end
