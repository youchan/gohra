require_relative 'card'

class Deck
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def render
    ul({ className: :table },
      li(nil,
        Card.el(rank: :A, suit: :hearts)
      )
    )
  end
end
