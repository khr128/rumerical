require 'rumerical'
module Rumerical
  class Matrix
    include LinearAlgebra
    attr_reader :rect
    attr_reader :inverse
    attr_reader :solutions

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
      tmp = deepcopy @m[i1][j1]
      @m[i1][j1] = deepcopy @m[i2][j2]
      @m[i2][j2] = tmp
    end

    def swap_rows row1, row2
      tmp_row = deepcopy @m[row1]
      @m[row1] = deepcopy @m[row2]
      @m[row2] = tmp_row
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
      @m[row].each{|col,row_value| self[row,col] = value * row_value}
    end

    def reduce_row row, other_row, value
      n = rect.col
      (1..n).each {|l| self[row,l] -= self[other_row,l]*value}
    end

    def largest_element_in_row row
      @m[row].values.max_by{|x| x.abs}.abs
    end
  end
end
