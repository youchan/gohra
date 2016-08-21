require_relative 'opponents_view'
require_relative 'layout_view'
require_relative 'hands_view'
require_relative '../controllers/application_controller'

class BoardView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def initial_state
    { account: nil }
  end

  def component_did_mount
    ApplicationController.current_account {|status, res| set_state(account: Account.new(res.json)) }
  end

  def render
    player_view = @state[:account] ? PlayerView.el({player: @state[:account]}) : nil
    puts "#{player_view.inspect}"

    div({className: 'playingCards faceImages'},
      OpponentsView.el,
      div({className: 'table'},
        LayoutView.el,
        div({className: 'stocks'},
          ul({className: 'deck'}, 15.times.map{ li({className: 'card back *'}) })
        )
      ),
      HandsView.el,
      div({class: 'player-aria'}, player_view )
    )
  end
end
