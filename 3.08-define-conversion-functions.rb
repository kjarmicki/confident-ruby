# Define an idempotent conversion function which is then applied to any incoming objects.
# For example, define a Point() method which yields a Point object when given pairs of ints, two-element arrays, spoecially formatted strings etc.

module Graphics
  module Conversions
    def Point(*args)
      case args.first
      #  go through well known types
      when Array then Point.new(*args.first)
      when Integer then Point.new(*args)
      when String then
        Point.new(*args.first.split(':').map(&:to_i))
      # allow user-defined types to be convertible to points
      when ->(arg){ arg.respond_to?(:to_point) }
        args.first.to_point
      when ->(arg){ arg.respond_to?(:to_ary) }
        Point.new(*args.first.to_ary)
      # side note on using lambdas as case conditions:
      # ->(...){...} is usable in case because Ruby uses === to determine if condition matches.
      # Proc objects have === operator overriden as alias to .call
      # Exmple: even = ->(x) { (x % 2) == 0 }
      # even === 4 will evaluate to true
      # even === 9 will evaluate to false
      else
        raise TypeError, "Cannot convert #{args.inspect} to Point"
      end
    end
  end

  Point = Struct.new(:x, :y) do
    def inspect
      "#{x}:#{y}"
    end

    def to_point
      self
    end
  end

  Pair = Struct.new(:a, :b) do
    def to_ary
      return [a, b]
    end
  end

  class Flag
    def initialize(x, y, flag_color)
      @x, @y, @flag_color = x, y, flag_color
    end

    def to_point
      Point.new(@x, @y)
    end
  end
end

include Graphics
include Graphics::Conversions

def convert_points
  points = [
    Point(Point.new(2, 3)),
    Point([9, 7]),
    Point(3, 5),
    Point("8:10"),
    Point(Pair.new(20, 23)),
    Point(Flag.new(42, 24, :red))
  ]
  points.each { |p| puts(p.inspect) }
end

convert_points()