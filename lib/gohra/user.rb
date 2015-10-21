class User
  include RuleBuilder
  attr_reader :states, :name

  def initialize(name)
    @name = name
  end

  def state(id)
    self.singleton_class.instance_method(id).bind(self).call
  end

  def do(state, turn)
  end
end

class Users < DelegateClass(Array)
  include StateBuilder
  include RuleBuilder

  def initialize(game)
    super([])
    @game = game
  end

  def turn(&block)
    @turn = block
  end

  def rule(id, &block)
    @rules = {} unless @rules
    @rules[id] = block
  end

  def set(users)
    replace(users)
    self.each do |user|
      bind_states(user)
      turn = @turn

      user.singleton_class.class_eval do
        define_method :turn do |game|
          puts "game = #{game}"
          game.instance_exec(user, &turn)
        end
      end

      @rules.each do |id, proc|
        puts "define_rule: #{id} user: #{user.name}"
        define_rule(@game, user, id, proc)
      end
    end
  end

  def except(user)
    self.reject {|u| u == user }
  end
end
