class Rule < DelegateClass(Game)
  class ValidationError < StandardError; end

  attr_reader :name, :context

  def initialize(game, context, name, proc)
    super(game)
    @context = context
    @name = name
    @proc = proc
  end

  def apply(*args)
    @context.notify_before_rule @name, self, args
    begin
      res = @context.instance_exec(*args, &@proc)
    rescue ValidationError => e
      @context.notify_validation_error(e, self)
      raise
    end
    @context.notify_after_rule @name, self, args, res
    res
  end
end
