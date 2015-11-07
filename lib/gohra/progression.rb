class Progression < DelegateClass(Game)
  include GlobalState

  def initialize(game, proc)
    super(game)
    @proc = proc
  end

  def run
    self.instance_eval(&@proc)
  end

  def skip
    puts "skip"
  end

  def to_s
    "Turns"
  end

  def inspect
    to_s
  end
end

