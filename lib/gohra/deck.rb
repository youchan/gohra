class Deck
  def initialize(cards)
    @cards = cards
  end

  def shuffle
    @cards.shuffle!
  end

  def deal(players)
    players.cycle do |player|
      break if @cards.length == 0
      yield(player, @cards.shift)
    end
  end
end
