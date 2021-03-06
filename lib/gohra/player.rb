module Gohra
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
          break if choice.nil? || choice.empty?
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

    def self.before_rule(name, &block)
      self.define_method("notify_before_#{name}", &block)
    end

    def self.after_rule(name, &block)
      self.instance_eval do
        define_method("notify_after_#{name}", &block)
      end
    end

    def self.state_updated(name, &block)
      self.instance_eval do
        define_method("notify_#{name}_updated", &block)
      end
    end

    def notify_before_rule(name, rule, args)
      method("notify_before_#{name}").call(rule: rule, args: args) if respond_to? "notify_before_#{name}"
    end

    def notify_after_rule(name, rule, args, result)
      method("notify_after_#{name}").call(rule: rule, args: args, result: result) if respond_to? "notify_after_#{name}"
    end

    def notify_state_updated(name, state)
      method("notify_#{name}_updated").call(state) if respond_to? "notity_#{name}_updated"
    end

    def notify_validation_error(err, rule)
      handle_validation_error(err, rule) if respond_to? :handle_validation_error
    end

    def notify(type, *args)
      method("notify_#{type}").call(*args) if respond_to? "notify_#{type}"
    end
  end

  class Players < DelegateClass(Array)
    include StateBuilder
    include RuleBuilder

    def initialize(game, &block)
      super([])
      @game = game
      instance_exec(&block)
    end

    def rule(id, &block)
      @rules = {} unless @rules
      @rules[id] = block
    end

    def set(players)
      replace(players)
      self.each do |player|
        bind_states(player.singleton_class)

        if @rules
          @rules.each do |id, proc|
            define_rule(@game, player, id, &proc)
          end
        end
      end
    end

    def except(player)
      self.reject {|u| u == player }
    end
  end
end
