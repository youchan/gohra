class Player
  include RuleBuilder
  include GlobalState

  attr_reader :states, :name

  def initialize(name)
    @name = name
  end

  def choose(state_id, range)
    state = self.state(state_id)
    wrap_event(:choose, state) do
      cards = nil
      while cards.nil?
        choice = input_choice(state, range)
        break if choice.empty?
        if block_given?
          cards = state.select(choice, &proc)
        else
          cards = state.select(choice)
        end
      end
      cards
    end
  end

  def wrap_event(type, params)
    method("before_#{type.to_s}").call(params) if respond_to? "before_#{type.to_s}"
    begin
      result = yield
    rescue => err
      method("error_#{type.to_s}").call(err) if respond_to? "error_#{type.to_s}"
      raise
    ensure
      method("after_#{type.to_s}").call(result) if respond_to? "after_#{type.to_s}"
    end
    result
  end

  def state(id)
    self.singleton_class.instance_method(id).bind(self).call
  end
end

class Players < DelegateClass(Array)
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

  def validation_rule(id, &block)
    @validation_rules = {} unless @validation_rules
    @validation_rules[id] = block
  end

  def set(players)
    replace(players)
    self.each do |player|
      bind_states(player.singleton_class)
      turn = @turn

      player.singleton_class.class_eval do
        define_method :turn do |game|
          game.instance_exec(player, &turn)
        end
      end

      if @rules
        @rules.each do |id, proc|
          define_rule(@game, player, id, &proc)
        end
      end

      if @validation_rules
        @validation_rules.each do |id, proc|
          define_validation_rule(@game, player, id, &proc)
        end
      end
    end
  end

  def except(player)
    self.reject {|u| u == player }
  end

  def notice_all(type, params)
    self.each do |player|
      player.notice(type, params)
    end
  end
end