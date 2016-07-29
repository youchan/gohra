class LayoutView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def component_will_mount
    @cards = [Card.new(suit: :hearts, rank: :A),Card.new(suit: :diams, rank: :A),Card.new(suit: :clubs, rank: :A),Card.new(suit: :spades, rank: :A)]
  end

  def render
    ul({ className: "layout" }, @cards.map{|card| CardView.el(card:card) })
  end
end
