module Rumerical
  module Integration
    class Integrator
      attr_accessor :a, :b, :f

      MAX_ROMBERG_ITERATIONS = 20

      def initialize a, b, f
        @a = a.to_f
        @b = b.to_f
        @f = f
      end

      def trapzd n
        return @s = 0.5*(b-a)*(f.call(b)+f.call(a)) if n == 1

        it = 1<<(n-1)
        del = (b-a)/it
        x = a + 0.5*del
        sum = (1..it).inject(0.0){|sum,j| (sum + f.call(x)).tap{x += del}}
        @s = 0.5*(@s + (b-a)*sum/it)
      end

      def qromb k, eps
        interpolator = Rumerical::Interpolation::Interpolator.new()
        interpolator.x << 1.0
        (1..MAX_ROMBERG_ITERATIONS).each do |j|
          interpolator.y << trapzd(j)
          if j >= k
            interpolator.polint(0.0, j-k, k).tap do |ss|
              return ss if interpolator.dy.abs < eps*ss.abs
            end
          end
          interpolator.x << 0.5*interpolator.x[j-1]
        end
        raise "Too many steps in qromb."
        0.0
      end
    end
  end
end
