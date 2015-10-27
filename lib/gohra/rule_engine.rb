require 'delegate'
require_relative 'state'
require_relative 'rule_builder'
require_relative 'user'
require_relative 'card'

class Game
  include StateBuilder
  include RuleBuilder

  attr_reader :rules

  def initialize(rule)
    self.instance_eval rule
  end

  def deck(params = nil)
    return @deck unless params

    @deck = Deck.new(Card::REGULAR_CARDS + (params[:include] || []) - (params[:exclude] || []))
  end

  def users(&block)
    return @users unless block_given?

    @users = Users.new self
    @users.instance_eval(&block)
    @users
  end

  def progression
    return @progression unless block_given?

    @progression = Progression.new(self, proc)
  end

  def rule(id, &block)
    define_rule(self, self, id, block)
  end

  def init(users)
    @users.set users
    bind_states(self)
  end

  def turns
    return @turns unless block_given?
    @turns = Turns.new(self)
    @turns.instance_eval(&proc)
    @turns
  end

  def joker(n)
    Array.new n, Card::JOKER
  end

  def end_of_game
    puts "############## end of game #################"
    exit
  end
end

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

class Progression < DelegateClass(Game)
  def initialize(game, proc)
    super(game)
    @proc = proc
    @turns = {}
  end

  def turn(id, &block)
    turn = @turns[id] || @turns[id] = Turn.new(__getobj__)
    self.singleton_class.class_eval do
      define_method id do
        turn
      end
    end
    turn.instance_eval(&block)
    turn
  end

  def run
    self.instance_eval(&@proc)
  end

  def skip
    puts "skip"
  end

  def to_s
    "Turns"
  end

  def inspect
    to_s
  end
end

class Turn < DelegateClass(Game)
  def initialize(game)
    super(game)
  end

  def should(&block)
    @proc = block
  end

  def skip
    puts "skip"
  end

  def til
    puts "til"
  end

  def expect(a)
     puts "expect"
  end

  def do
    self.instance_eval(&@proc)
  end

  def to_s
    "Turn"
  end

  def inspect
    to_s
  end
end

class Rule < DelegateClass(Game)
  attr_reader :proc

  def initialize(game, &block)
    super(game)
    @proc = block
  end
end

class RuleEngine
  def initialize(rule, users)
    @game = Game.new(rule)
    @users = users
  end

  def run
    @game.init(@users)
    @game.progression.run
    @game.progression.each_turn do |turn|
      turn.do
    end
  end
end
