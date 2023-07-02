# Hide parameter object construction and yield the parameter object or a parameter builder object

require 'delegate'

Point = Struct.new(:x, :y, :name, :magnitude) do
  def initialize(x, y, name='', magnitude=5)
    super(x, y, name, magnitude)
  end

  def magnitude=(magnitude)
    raise ArgumentError unless (1..20).include?(magnitude)
    self['magnitude'] = magnitude
  end

  def draw_on(map)
    puts "drawing point #{self}"
  end
end

class StarredPoint < Point
  def draw_on(map)
    # draw a star instead of a dot
    super
    puts "drawing starred point"
  end
end

class FuzzyPoint < SimpleDelegator
  def initialize(point, fuzzy_radius)
    super(point)
    @fuzzy_radius = fuzzy_radius
  end

  def draw_on(map)
    super # draw the point
    # draw a circle around the point
    puts "drawing circle around the point"
  end
end

class Map
  def draw_point(point_or_x, y=:y_not_set_in_draw_point)
    point = point_or_x.is_a?(Integer) ? Point.new(point_or_x, y) : point_or_x
    builder = PointBuilder.new(point)
    yield(builder) if block_given?
    builder.point.draw_on(self)
  end

  def draw_starred_point(x, y, &point_customization)
    draw_point(StarredPoint.new(x, y), &point_customization)
  end
end

class PointBuilder < SimpleDelegator
  def initialize(point)
    super(point)
  end

  def fuzzy_radius=(fuzzy_radius)
    # __setobj__ is used to replace the wrapped object in a SimpleDelegator
    __setobj__(FuzzyPoint.new(point, fuzzy_radius))
  end

  def point
    # __getobj__ is a way to access wrapped object directly
    __getobj__
  end
end

# now drawing ordinary points or starred points requires no knowledge of the Point class family

def use_map()
  map = Map.new
  map.draw_point(7, 9)
  map.draw_starred_point(21, 37)

  # code blocks - allow for in-flight customization of points right before drawing
  # advantage: access to the actual values, so things like point.magnitude *= 2 become possible
  map.draw_point(3, 4) do |point|
    point.magnitude *= 2
  end
  map.draw_starred_point(22, 38) do |point|
    point.name = "homepage"
    point.fuzzy_radius = 30
  end
end

use_map()

# an advantage of this design is that implementation of the library is decoupled from its interface
# the client doesn't know about any of the point classes, and their internal representation could change without breaking the clients

