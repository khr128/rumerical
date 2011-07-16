module Rumerical
  module LinearAlgebra

    def lu_unscramble m
      n = @index.rect.row
      n.downto(1).each do |i|
        m.swap_rows(i, @index[i,1]) if i != @index[i,1]
      end
    end

    def extract_l index
      Matrix.new({}).tap do |l|
        @m.each do |row,v|
          v.each do |col, e|
            l[row,col] = e if row > col
            l[row,col] = 1 if row == col
          end
        end
      end
    end

    def extract_u index
      Matrix.new({}).tap do |u|
        @m.each do |row,v|
          v.each do |col, e|
            u[row,col] = e if row <= col
          end
        end
      end
    end

    def l
      @l ||= @lu.extract_l(@index)
    end

    def u
      @u ||= @lu.extract_u(@index)
    end

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
