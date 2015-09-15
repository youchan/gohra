class User
  include RuleBuilder
  attr_reader :states, :name

  def initialize(name)
    @name = name
  end

  def choose(state_id, range)
    state = self.state(state_id)
    p state
    choice = []
    range.to_a.each do |i|
      print "#{i}番目のカード"
      card = gets.chomp
      break if card.empty?
      choice << card.to_i
    end
    return nil if choice.empty?
    state.select(choice)
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
        define_method :turn do
          turn.call self
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
