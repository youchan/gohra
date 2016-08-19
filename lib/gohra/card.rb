module Gohra
  class Card
    include Comparable

    attr_reader :suit, :number

    def initialize(suit, number)
      @suit = suit
      @number = number
    end

    NAMES_OF_NUMBER = %w(JOKER ACE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN JACK QUEEN KING)

    REGULAR_CARDS = %i(spade diamond club heart).flat_map do |suit|
      (1..13).map do |num|
        const_set(NAMES_OF_NUMBER[num] + "_OF_" + suit.to_s.upcase, Card.new(suit, num))
      end
    end

    SUIT_CHAR = {spade:"\u2660", diamond:"\u2666", club:"\u2663", heart:"\u2665"}
    NUMBER_CHAR = %w(_ A 2 3 4 5 6 7 8 9 10 J Q K)

    JOKER = Card.new(:joker, 0)

    def to_s
      return NAMES_OF_NUMBER[0] if @suit == :joker
      #NAMES_OF_NUMBER[@number] + "_OF_" + suit.to_s.upcase
      SUIT_CHAR[suit] + NUMBER_CHAR[@number]
    end

    def <=>(c)
      Card.index_of(self) - Card.index_of(c)
    end

    def self.index_of(card)
      case card.suit
      when :spade
        card.number - 1
      when :diamond
        card.number + 13 - 1
      when  :club
        card.number + 13 * 2 - 1
      when :heart
        card.number + 13 * 3 - 1
      when :joker
        13 * 4
      end
    end

    def inspect
      to_s
    end
  end
end
