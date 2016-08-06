require_relative 'opponents_view'
require_relative 'layout_view'
require_relative 'hands_view'

class BoardView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def render
    div({className: 'playingCards faceImages'},
      OpponentsView.el,
      div({className: 'table'},
        LayoutView.el,
        div({className: 'stocks'},
          ul({className: 'deck'}, 15.times.map{ li({className: 'card back *'}) })
        )
      ),
      HandsView.el
    )
  end
end
