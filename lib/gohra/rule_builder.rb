module RuleBuilder
  def define_rule(game, obj, id, proc)
    obj.singleton_class.class_eval do
      rule = Rule.new(game, &proc)
      define_method("test_#{id}", &rule.proc)
      define_method(id) do |*args|
        self.singleton_class.instance_method("test_#{id}").bind(self).call(*args)
      end
    end
  end
end
