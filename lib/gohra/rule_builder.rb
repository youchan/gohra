module RuleBuilder
  def define_rule(game, obj, id)
    obj.singleton_class.class_eval do
      rule = Rule.new(game, obj, id, proc)
      define_method(id) {|*args| rule.apply(*args) }
    end
  end

  def validate_error(msg)
    raise Rule::ValidateError.new msg
  end
end
