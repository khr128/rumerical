require 'rumerical'
module Rumerical
  class Matrix
    include LinearAlgebra
    attr_reader :rect
    attr_reader :inverse
    attr_reader :solutions


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
            (1..@rect.col).each{|k| result[i,j] += self[i,k]*matrix[k,j]}
          end
        end
      end
    end

    def transform_with matrix
      Rumerical::Matrix.new({}).tap do |result|
        (1..@rect.row).each do |i|
          (1..@rect.col).each do |j|
            result[i,j] = yield self[i,j], matrix[i,j]
          end
        end
      end
    end

    def + matrix
      transform_with(matrix){|this, other| this + other}
    end
    def - matrix
      transform_with(matrix){|this, other| this - other}
    end

    def swap i1, j1, i2, j2
      tmp = deepcopy @m[i1][j1]
      @m[i1][j1] = deepcopy @m[i2][j2]
      @m[i2][j2] = tmp
    end

    def swap_rows row1, row2
      tmp_row = deepcopy @m[row1]
      @m[row1] = deepcopy @m[row2]
      @m[row2] = tmp_row
    end

    def multiply_row_by value, row
      @m[row].each{|col,row_value| self[row,col] = value * row_value}
    end

    def reduce_row row, other_row, value
      (1..rect.col).each {|l| self[row,l] -= self[other_row,l]*value}
    end

    def largest_element_in_row row
      row = @m[row]
      return 0 unless row
      row.values.max_by{|x| x.abs}.abs
    end

    def set_columns other, start
      (1..other.rect.col).each do |col|
        col_s = col + start - 1
        (1..other.rect.row).each{|row| self[row, col_s] = other[row, col]}
      end
    end
  end
end
