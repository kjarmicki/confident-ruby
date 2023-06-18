# Define your own conversion protocol for converting arbitrary objects to instances of the target class.

require 'forwardable'

def report_altitude_change(current_altitude, previous_altitude)
  # conversion here is required, so every object that doesn't have .to_meters method will trigger a NoMethodError
  # which is exactly what we want
  change = current_altitude.to_meters - previous_altitude.to_meters
  puts("changed altitude", change)
end

class Meters
  extend Forwardable

  def_delegators :@value, :to_s, :to_int, :to_i

  def initialize(value)
    @value = value
  end

  def -(other)
    self.class.new(value - other.value)
  end

  def to_meters
    self
  end

  protected

  attr_reader :value
end

class Feet
  extend Forwardable

  def_delegators :@value, :to_s, :to_int, :to_i

  def initialize(value)
    @value = value
  end

  def -(other)
    self.class.new(value - other.value)
  end

  def to_meters
    Meters.new((value * 0.3048).round)
  end

  protected

  attr_reader :value
end