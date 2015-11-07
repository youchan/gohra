module RuleBuilder
  def define_rule(game, obj, id)
    obj.singleton_class.class_eval do
      rule = Rule.new(game, obj, id, proc)
      define_method(id) {|*args| rule.apply(*args) }
    end
  end

  def validation_error(msg)
    raise Rule::ValidationError.new msg
  end
end
