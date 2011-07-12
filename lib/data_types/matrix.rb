module Rumerical
  class Matrix
    def initialize mi
      @m = mi
    end

    def [] i,j
      value = @m[i][j]
      value ? value : 0
    end

  end
end
