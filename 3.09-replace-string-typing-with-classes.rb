# Replace strings that have special meaning with user-defined types.

class StringlyTypedTrafficLight
  def change_to(state)
    @state = state
  end

  def signal
    case @state
    when "stop" then turn_on_lamp(:red)
    when "caution"
      turn_on_lamp(:yellow)
      ring_warning_bell
    when "proceed" then turn_on_lamp(:green)
    end
  end

  def next_state
    case @state
    when "stop" then "proceed"
    when "proceed" then "caution"
    when "caution" then "stop"
    end
  end

  def turn_on_lamp(color)
    puts "Turning on #{color} lamp"
  end

  def ring_warning_bell
    puts "Ring ring ring!"
  end
end

def problems_with_stingly_typed_traffic_light
  light = StringlyTypedTrafficLight.new
  light.change_to("PROCEED") # wrong, uppercase
  light.signal
  puts "Next state: #{light.next_state.inspect}"

  light.change_to(:stop) # wrong, symbol
  light.signal
  puts "Next state: #{light.next_state.inspect}"
end

problems_with_stingly_typed_traffic_light()

class StatefulTrafficLight
  State = Struct.new(:name, :next_state) do
    def to_s
      name
    end
  end

  VALID_STATES = [
    STOP = State.new("stop", "proceed"),
    CAUTION = State.new("caution", "stop"),
    PROCEED = State.new("proceed", "caution"),
  ]

  def change_to(state)
    raise ArgumentError unless VALID_STATES.include?(state)
    @state = state
  end

  def signal
    case @state
    when STOP then turn_on_lamp(:red)
    when CAUTION
      turn_on_lamp(:yellow)
      ring_warning_bell
    when PROCEED then turn_on_lamp(:green)
    end
  end

  def next_state
    @state.next_state
  end

  def turn_on_lamp(color)
    puts "Turning on #{color} lamp"
  end

  def ring_warning_bell
    puts "Ring ring ring!"
  end
end

# If we want refactor .signal method to use State polymorphism and still have the special case for caution ringing a bell,
# we can change them from structs to subclasses and define their behavior in methods

class PolymorphicStateTrafficLight
  class State
    def to_s
      name
    end

    def name
      self.class.name.split('::').last.downcase
    end

    def signal(traffic_light)
      traffic_light.turn_on_lamp(color.to_sym)
    end
  end

  class Stop < State
    def color; 'red'; end
    def next_state; Proceed.new; end
  end

  class Caution < State
    def color; 'yellow'; end
    def next_state; Stop.new; end
    def signal(traffic_light)
      super
      traffic_light.ring_warning_bell
    end
  end

  class Proceed < State
    def color; 'green'; end
    def next_state; Caution.new; end
  end

  def change_to(state)
    @state = State(state)
  end

  def next_state
    @state.next_state
  end

  def signal
    @state.signal(self)
  end

  def turn_on_lamp(color)
    puts "Turning on #{color} lamp"
  end

  def ring_warning_bell
    puts "Ring ring ring!"
  end

  private

  def State(state)
    case state
    when State then state
    else self.class.const_get(state.to_s.capitalize).new
    end
  end
end

def polymorphic_state_examples
  light = PolymorphicStateTrafficLight.new
  light.change_to(:caution)
  light.signal
  puts "Next state is: #{light.next_state}"
end

polymorphic_state_examples()

# Large switch statement was replaced with calls to polymorphic State instances.
# The code is now easier to read and extend.
