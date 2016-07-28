require_relative 'card_view'

class DeckView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def render
    ul({},
      li(nil,
        CardView.el(card: Card.new(rank: :A, suit: :hearts))
      ),
      li(nil,
        CardView.el(card: Card.new(rank: :A, suit: :hearts))
      ),
      li(nil,
        CardView.el(card: Card.new(rank: :A, suit: :hearts))
      ),
      li(nil,
        CardView.el(card: Card.new(rank: :A, suit: :hearts))
      ),
      li(nil,
        CardView.el(card: Card.new(rank: :A, suit: :hearts))
      ),
      li(nil,
        CardView.el(card: Card.new(rank: :A, suit: :hearts))
      )
    )
  end
end
