# Define new implicit conversion protocols mimicking Ruby's native protocols such as .to_path

# If we expose a library and accept to_coords then client classes implementing this method are usable within the library.
# Kind of like interfaces, but less explicit.

# start and end should both be [x, y] pairs or should define to_coords to convert to an [x, y] pair
def draw_line(start, endpoint)
  start = start.to_coords if start.respond_to?(:to_coords)
  start = start.to_ary

  endpoint = endpoint.to_coords if endpoint.respond_to?(:to_coords)
  endpoint = endpoint.to_ary
  puts("drawing line from #{start} to #{endpoint}")
end

class Point
  attr_reader :x, :y, :name

  def initialize(x, y, name = nil)
    @x, @y, @name = x, y, name
  end

  def to_coords
    [x, y]
  end
end

# Supposed benefit here is that we can pass the entire Point instance as an argument rather than calling .to_coords
# on the Point and passing the result of that. I think that's sketchy. It forces draw_line to be aware of :to_coords.
def polymorphic_draw_line()
  start = Point.new(21, 37)
  endpoint = [12, 73]
  draw_line(start, endpoint)
end

polymorphic_draw_line()
