# Combine parameters that commonly appear together into a new class

class Map
  def draw_point(x, y)

  end

  def draw_line(x1, y1, x2, y2)

  end
end

# x and y will almost always appear together, so it makes sense to put them in class

Point = Struct.new(:x, :y)

class StructMap
  def draw_point(point)

  end

  def draw_line(point1, point2)

  end
end

# points will eventually "attract" methods

DrawablePoint = Struct.new(:x, :y) do
  def draw_on(map)

  end
end

class MapUsingDrawablePoints
  def draw_point(point)
    point.draw_on(self)
  end

  def draw_line(point1, point2)
    point1.draw_on(self)
    point2.draw_on(self)
  end
end

# according to the book, points can then even support special cases of drawing, like starred point or fuzzy point (with radius)
# not sure if it's a good idea for a point to know how to render itself, rather than having some sort of point view, but here we go

class StarredPoint < DrawablePoint
  def draw_on(map)
    # draw a star instead of a dot
  end
end

# composition done through inheritance, oh boy :)
class FuzzyPoint < SimpleDelegator
  def initialize(point, fuzzy_radius)
    super(point)
    @fuzzy_radius = fuzzy_radius
  end

  def draw_on(map)
    super # draw the point
    # draw a circle around the point
  end
end
