class Rule < DelegateClass(Game)
  attr_reader :proc

  def initialize(game, context, name, proc)
    super(game)
    @context = context
    @name = name
    @proc = proc
  end

  def validate(*args)
    unless @context.instance_exec(*args, &@proc)
      raise "validate error: #{@name}"
    end
  end
end
