module Rumerical
  class Point
    attr_accessor :x, :y
    alias :row :x
    alias :col :y
    alias :row= :x=
    alias :col= :y=

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
