require 'rumerical'
module Rumerical
  class Matrix
    include LinearAlgebra
    attr_reader :rect
    attr_reader :inverse
    attr_reader :solutions
    attr_reader :l, :u


    def initialize mi
      @m = mi
      update_rect
    end

    def self.identity n
      Matrix.new({}.tap do |m|
        (1..n).each do |row|
          m[row] = {}
          m[row][row] = 1
        end
      end)
    end

    def update_rect
      rect_col = @m.inject(0) do |max_y, x|
        newmax = x[1].keys.max
        max_y = newmax if(newmax && newmax > max_y)
        max_y
      end

      @rect = Rumerical::Point.new(@m.keys.max.to_i, rect_col)
    end

    def [] i,j
      row = @m[i]
      return 0 unless row
      value = @m[i][j]
      value ? value : 0
    end

    def []= i,j,value
      @m[i] ||= {}
      @m[i][j] = value
      @rect.row = i if(i > @rect.row)
      @rect.col = j if(j > @rect.col)
    end

    def * matrix
      Rumerical::Matrix.new({}).tap do |result|
        (1..@rect.row).each do |i|
          (1..matrix.rect.col).each do |j|
            (1..@rect.col).each do |k|
              result[i,j] += self[i,k]*matrix[k,j]
            end
          end
        end
      end
    end

    def swap i1, j1, i2, j2
      temp = self[i1,j1]
      self[i1,j1] = self[i2,j2]
      self[i2,j2] = temp
    end

    def swap_rows row1, row2
      n = rect.col
      (1..n).each {|l| swap(row1,l, row2,l)}
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

    def multiply_row_by value, row
      n = rect.col
      (1..n).each {|l| self[row,l] *= value}
    end

    def reduce_row row, other_row, value
      n = rect.col
      (1..n).each {|l| self[row,l] -= self[other_row,l]*value}
    end

  end
end
