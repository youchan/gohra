require_relative 'state'
require_relative 'deck'
require_relative 'rule_builder'

module GlobalState
end

class Game
  include RuleBuilder
  include StateBuilder
  include GlobalState

  attr_reader :rules, :players

  def initialize(rule)
    self.instance_eval rule
  end

  def deck(params = nil)
    return @deck unless params

    @deck = Deck.new(Card::REGULAR_CARDS + (params[:include] || []) - (params[:exclude] || []))
  end

  def player(&block)
    @players = Players.new(self, &block)
  end

  def progression
    return @progression unless block_given?

    @progression = Progression.new(self, proc)
  end

  def rule(id, &block)
    define_rule(self, self, id, &block)
  end

  def init(players)
    @players.set players
    bind_states(GlobalState)
  end

  def notify_before_rule(name, rule, *args)
    players.each {|player| player.notify_before_rule(name, rule, *args) }
  end

  def notify_after_rule(name, rule, *args)
    players.each {|player| player.notify_after_rule(name, rule, *args) }
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
require_relative 'player'
require_relative 'card'
require_relative 'progression'
