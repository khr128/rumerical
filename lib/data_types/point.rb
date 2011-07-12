module Rumerical
  class Point
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(other)
      eql? other
    end

    def eql?(other)
      @x == other.x && @y == other.y
    end

  end
end
