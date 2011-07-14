module MatrixMatchers
  class Within
    def initialize tolerance
      @tolerance = tolerance
    end

    def of expected
      @expected = expected
      self
    end

    def matches? target
      @target = target
      return false unless @target.rect == @expected.rect
      (1..@target.rect.x).each do |i|
        (1..@target.rect.y).each do |j|
          return false unless (@target[i,j] - @expected[i,j]).abs < @tolerance
        end
      end
      true
    end

    def failure_message
      "all elements of #{@target.inspect} expected to be within #{@tolerance} of #{@expected.inspect}"
    end

    def negative_failure_message
      "no element of #{@target.inspect} expected to be within #{@tolerance} of #{@expected.inspect}"
    end
  end

  def have_all_elements_within tolerance
    Within.new tolerance
  end

end
