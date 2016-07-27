class Card
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  SUIT_CHAR = {spades:"\u2660", diamonds:"\u2666", clubs:"\u2663", hearts:"\u2665"}

  def render
    rank = @props[:rank]
    suit = @props[:suit]

    a({ className: "card rank-#{rank.downcase} #{suit}" },
      span({ className: "rank" }, rank.upcase),
      span({ className: "suit" }, SUIT_CHAR[suit])
    )
  end
end
