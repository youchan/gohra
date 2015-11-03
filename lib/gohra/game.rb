require_relative 'state'
require_relative 'deck'
require_relative 'rule_builder'

module GlobalState
end

class Game
  include RuleBuilder
  include StateBuilder
  include GlobalState

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
    define_rule(self, self, id, &block)
  end

  def validation_rule(id, &block)
    define_validation_rule(self, self, id, &block)
  end

  def init(users)
    @users.set users
    bind_states(GlobalState)
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

require_relative 'rule'
require_relative 'user'
require_relative 'card'
require_relative 'progression'
