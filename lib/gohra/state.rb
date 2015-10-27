module StateBuilder
  def state(id, type, count = 1, init = nil)
    @states = [] unless @states
    state = block_given? ? State.new(self, id, type, count, init, &proc) : State.new(self, id, type, count, init)
    @states << state
    state
  end

  def bind_states(obj)
    states = @states || []
    obj.singleton_class.class_eval do
      states.each do |state|
        s = state.clone.init
        define_method(state.id) do
          s
        end
        define_method((state.id.to_s + "=").to_sym) do |value|
          s.value = value
        end
      end
    end
  end
end

class State
  attr_reader :id, :type
  attr_accessor :value

  def initialize(game, id, type, size = 1, init_value = nil)
    @game = game
    @id = id
    @size = size
    @type = type
    @value = init_value

    if block_given?
      @initializer = proc
    end
  end

  def init
    unless @value
      case @size
        when :any
          @value = []
        when Numeric
          @value = Array(@size) if @size > 1
      end
    end

    instance_eval(&@initializer) if @initializer

    self
  end

  def size(s)
    @size = s
 
    if block_given?
      @initializer = proc
    end

    self
  end

  def is_not(v)
    return @value == v
  end

  def cycle
    if @value
      @value.cycle(&proc)
    else
      case @type
        when :users
          @game.users.cycle(&proc)
      end
    end
  end

  def [](index)
    @value[index]
  end

  def count
    @value.count
  end

  def <<(state)
    raise "don't allowed except size is any. #{self}" unless @size == :any
    @value << state
  end

  def select(indexes)
    choice = indexes.map {|i| @value[i] }
    if block_given?
      return nil unless yield choice
    end
    @value -= choice
    choice
  end

  def clone
    State.new(@game, @id, @type, @size, @value, &@initializer)
  end

  def to_s
    "STATE::#{@id}(#{@type}[#{@size}]) = #{@value.inspect}"
  end

  def inspect
    to_s
  end
end
