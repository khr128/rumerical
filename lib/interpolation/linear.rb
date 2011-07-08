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
  end
end
