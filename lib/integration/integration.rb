module Rumerical
  module Integration
    class Integrator
      attr_accessor :a, :b, :f
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
    end
  end
end
