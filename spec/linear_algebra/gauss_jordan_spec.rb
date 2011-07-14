require 'spec_helper'

describe "Gauss-Jordan elimination" do
  it "should raise exception if matrix is singular" do
    mi = {
      1 => { 1=>1, 2=>1, 3=>1},
      2 => { 1=>1, 2=>1, 3=>1},
      3 => { 1=>1, 2=>1, 3=>1},
    }
    m = Rumerical::Matrix.new(mi)
    lambda{m.gaussj(m)}.should raise_error(RuntimeError, "gaussj: Singular matrix")
  end
end
