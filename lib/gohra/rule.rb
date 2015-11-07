class Rule < DelegateClass(Game)
  attr_reader :name, :context

  def initialize(game, context, name, proc)
    super(game)
    @context = context
    @name = name
    @proc = proc
  end

  def apply(*args)
    @context.notify_before_rule @name, self, *args
    @context.instance_exec(*args, &@proc)
    @context.notify_after_rule @name, self, *args
  end
end
