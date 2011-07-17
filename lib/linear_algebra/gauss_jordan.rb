module Rumerical
  module LinearAlgebra
    include Rumerical::Util

    def gaussj b
      @inverse = deepcopy self
      @solutions = deepcopy b

      indxc = Matrix.new({})
      indxr = Matrix.new({})
      ipiv = Matrix.new({})

      n = @inverse.rect.col
      (1..n).each do |i|
        irow, icol = @inverse.find_pivot(ipiv)
        ipiv[icol,1] += 1

        @inverse.swap_rows(irow, icol)
        raise "gaussj: Singular matrix" if @inverse[icol, icol] == 0.0

        @solutions.swap_rows(irow, icol)

        indxr[i,1] = irow
        indxc[i,1] = icol

        pivinv = 1.0/@inverse[icol,icol]
        @inverse[icol, icol] = 1.0
        
        @inverse.multiply_row_by(pivinv, icol)
        @solutions.multiply_row_by(pivinv, icol)

        (1..n).each do |ll|
          next if ll == icol
          dum = @inverse[ll,icol]
          @inverse[ll,icol] = 0
          @inverse.reduce_row(ll, icol, dum)
          @solutions.reduce_row(ll, icol, dum)
        end
      end

      #unswap columns
      n.downto(1).each do |l|
        next if indxr[l,1] == indxc[l,1]
        (1..n).each{|k| @inverse.swap(k,indxr[l,1],k,indxc[l,1])}
      end
    end

    def find_pivot pivot_index
      big = 0
      irow = icol = 0
      n = rect.col
      (1..n).each do |j|
        next if pivot_index[j,1] == 1
        (1..n).each do |k|
          raise "find_pivot: Singular Matrix" if pivot_index[k,1] > 1
          next unless pivot_index[k,1] == 0
          next unless self[j,k].abs >= big

          big = self[j,k].abs
          irow = j
          icol = k
        end
      end
      return irow, icol
    end
  end
end
