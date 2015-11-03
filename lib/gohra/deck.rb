class Deck
  def initialize(cards)
    @cards = cards
  end

  def shuffle
    @cards.shuffle!
  end

  def deal(users)
    users.cycle do |user|
      break if @cards.length == 0
      yield(user, @cards.shift)
    end
  end
end
