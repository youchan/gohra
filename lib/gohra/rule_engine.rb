require 'delegate'
require_relative 'game'

class RuleEngine
  def initialize(rule, players)
    @game = Game.new(rule)
    @players = players
  end

  def run
    @game.init(@players)
    @game.progression.run
    @game.progression.each_turn do |turn|
      turn.do
    end
  end
end
