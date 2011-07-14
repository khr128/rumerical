require 'rumerical'
module Rumerical
  class Matrix
    include LinearAlgebra
    attr_reader :rect
    attr_reader :inverse

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
      rect_y = @m.inject(0) do |max_y, x|
        newmax = x[1].keys.max
        max_y = newmax if(newmax && newmax > max_y)
        max_y
      end

      @rect = Rumerical::Point.new(@m.keys.max.to_i, rect_y)
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
      @rect.x = i if(i > @rect.x)
      @rect.y = j if(j > @rect.y)
    end

    def * matrix
      Rumerical::Matrix.new({}).tap do |result|
        (1..@rect.x).each do |i|
          (1..matrix.rect.y).each do |j|
            (1..@rect.y).each do |k|
              result[i,j] += self[i,k]*matrix[k,j]
            end
          end
        end
      end
    end
  end
end
