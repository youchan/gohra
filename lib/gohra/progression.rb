class Progression < DelegateClass(Game)
  include GlobalState

  def initialize(game, proc)
    super(game)
    @proc = proc
    @turns = {}
  end

  def turn(id, &block)
    turn = @turns[id] || @turns[id] = Turn.new(__getobj__)
    self.singleton_class.class_eval do
      define_method id do
        turn
      end
    end
    turn.instance_eval(&block)
    turn
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

class Turn < DelegateClass(Game)
  def initialize(game)
    super(game)
  end

  def should(&block)
    @proc = block
  end

  def skip
    puts "skip"
  end

  def til
    puts "til"
  end

  def expect(a)
     puts "expect"
  end

  def do
    self.instance_eval(&@proc)
  end

  def to_s
    "Turn"
  end

  def inspect
    to_s
  end
end

