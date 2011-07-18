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

  it "should calculate the determinant correctly" do
    m = Rumerical::Matrix.new({
      1=>{1=>1.0, 2=>1.5, 3=>1.8},
      2=>{1=>-1.1, 2=>2.5, 3=>2.8},
      3=>{1=>-11.1, 2=>12.5, 3=>-1.8}
    })
    m.ludcmp
    expected_det = m[1,1]*(m[2,2]*m[3,3]-m[3,2]*m[2,3]) -
      m[1,2]*(m[2,1]*m[3,3]-m[3,1]*m[2,3]) +
      m[1,3]*(m[2,1]*m[3,2]-m[3,1]*m[2,2])
    m.ludet.should be_within(1.0e-13).of(expected_det)
  end

end

