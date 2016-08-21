require_relative 'login_users_view'
require_relative '../controllers/game_controller'

class LobbyView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def start_game
    GameController.start do |status, res|
      if status == :success
        `window.location = '/'`
      end
    end
  end

  def render
    div({className: 'lobby'},
      LoginUsersView.el,
      div({class: 'has-text-centered'},
        a({class: 'button is-danger is-large', onClick: self.method(:start_game)}, 'Start Game'),
      )
    )
  end
end
