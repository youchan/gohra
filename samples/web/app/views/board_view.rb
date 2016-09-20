require_relative 'opponents_view'
require_relative 'layout_view'
require_relative 'hands_view'
require_relative '../controllers/application_controller'

class BoardView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def initial_state
    { account: nil, opponents: [] }
  end

  def component_did_mount
    ApplicationController.board_state {|status, res| set_state(account: Account.new(res.json[:account]), opponents: res.json[:opponents].map{|acc| Account.new(acc) }) }
  end

  def render
    div({className: 'playingCards faceImages'},
      OpponentsView.el(opponents: @state[:opponents]),
      div({className: 'table'},
        LayoutView.el,
        div({className: 'stocks'},
          ul({className: 'deck'}, 15.times.map{ li({className: 'card back *'}) })
        )
      ),
      HandsView.el,
      div({class: 'player-aria'}, PlayerView.el({player: @state[:account]}))
    )
  end
end
