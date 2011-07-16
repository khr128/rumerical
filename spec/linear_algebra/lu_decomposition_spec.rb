require 'spec_helper'

describe "LU Decomposition" do
  it "should raise exception if matrix is singular" do
    mi = {
      1 => { 1=>1, 2=>1, 3=>1},
      3 => { 1=>1, 2=>1, 3=>1},
    }
    m = Rumerical::Matrix.new(mi)
    lambda{m.ludcmp}.should raise_error(RuntimeError, "ludcmp: Singular matrix")
  end
end

