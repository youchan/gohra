class CardView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  SUIT_CHAR = {spades:"\u2660", diamonds:"\u2666", clubs:"\u2663", hearts:"\u2665"}

  def render
    card = @props[:card]

    a({ className: "card rank-#{card.rank.downcase} #{card.suit}" },
      span({ className: "rank" }, card.rank.upcase),
      span({ className: "suit" }, SUIT_CHAR[card.suit])
    )
  end
end
