module Rumerical
  module LinearAlgebra
    def ludcmp
      vv = Rumerical::Matrix.new({})
      @determinant_sign = 1
      n = rect.col
      (1..n).each do |i|
        vv[i,1] = 1.0/largest_element_in_row(i)
      end

      @lu = deepcopy self
      @l = @u = nil
      @index = Rumerical::Matrix.new({})

      (1..n).each do |j|
        (1..j-1).each do |i|
          sum = @lu[i,j]
          (1..i-1).each{|k| sum -= @lu[i,k]*@lu[k,j]}
          @lu[i,j] = sum
        end

        big = 0
        imax = 0
        (j..n).each do |i|
          sum = @lu[i,j]
          (1..j-1).each{|k| sum -= @lu[i,k]*@lu[k,j]}
          @lu[i,j] = sum
          dum = vv[i,1]*sum.abs
          if dum > big
            big = dum
            imax = i
          end
        end

        if j != imax
          @lu.swap_rows(imax, j)
          @determinant_sign = -@determinant_sign
          vv[imax,1] = vv[j,1]
        end

        @index[j,1] = imax
        @lu[j,j] = Rumerical::Util::TINY if @lu[j,j] == 0.0

        next if j == n
        (j+1..n).each{|i| @lu[i,j] /= @lu[j,j]}

      end
    end
  end
end
