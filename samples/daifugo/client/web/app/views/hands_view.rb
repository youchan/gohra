require_relative 'card_view'

class HandsView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def component_will_mount
    @cards = 10.times.map { Card.new suit: [:hearts, :diams, :clubs, :spades].sample, rank: [?A, ?J, ?Q, ?K, (2..9).map(&:to_s)].flatten.sample }
  end

  def render
    ul({}, @cards.map {|card| li(nil, CardView.el(card: card)) })
  end
end
