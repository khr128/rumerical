module Rumerical
  module Interpolation
    class Linear
      def initialize(p1, p2)
        @start = p1
        @end = p2
      end
      def [] x
       @start.y + (x-@start.x)*(@end.y-@start.y)/(@end.x-@start.x)
      end
    end

    class Interpolator
      attr_accessor :x, :y
      attr_reader :dy

      def initialize
        @x = []
        @y = []
      end

      def polint xi, offset, order
        xa = x[offset,order]
        ya = y[offset,order]

        dif = (xi - xa[0]).abs
        c = []
        d = []
        ns = 1
        xa.each_with_index do |xai, i|
          dift = (xi - xai).abs
          if dift < dif
            ns = i+1
            dif = dift
          end
          c[i] = ya[i]
          d[i] = ya[i]
        end

        yi = ya[ns-1]
        ns -= 1

        (1..order-1).each do |m|
          (1..order-m).each do |i|
            ho = xa[i-1] - xi
            hp = xa[i+m-1] - xi
            w = c[i]-d[i-1]
            den = ho - hp
            raise "Error in polint" if den == 0.0
            den = w/den
            d[i-1] = hp*den
            c[i-1] = ho*den
          end
          if 2*ns < order - m
            @dy = c[ns]
          else
            @dy = d[ns-1]
            ns-=1
          end
          yi += @dy
        end
        yi
      end
    end
  end
end
