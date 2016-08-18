require_relative 'login_users_view'

class LobbyView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def render
    div({className: 'lobby'},
      LoginUsersView.el,
      div({class: 'has-text-centered'},
        a({class: 'button is-danger is-large'}, 'Start Game'),
      )
    )
  end
end
