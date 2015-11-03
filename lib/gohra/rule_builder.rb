module RuleBuilder
  def define_rule(game, obj, id)
    obj.singleton_class.class_eval do
      rule = Rule.new(game, obj, id, proc)
      define_method(id, &rule.proc)
    end
  end

  def define_validation_rule(game, obj, id)
    obj.singleton_class.class_eval do
      rule = Rule.new(game, obj, id, Proc.new(&proc))
      define_method(id) {|*args| rule.validate(*args) }
    end
  end
end
