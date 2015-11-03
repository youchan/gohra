require 'delegate'
require_relative 'game'

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
