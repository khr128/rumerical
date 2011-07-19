require 'spec_helper'

include Rumerical::Util

describe "Rumerical::Util" do
  it "should make deep copy" do
    expected_value = 1.234
    expected_value2 = 7.654

    m1 = Rumerical::Matrix.new({1 => {1 => expected_value}})
    m2 = m1
    m1[1,1].should == expected_value
    m2[1,1].should == expected_value

    m2[1,1] = expected_value2

    m1[1,1].should == expected_value2
    m2[1,1].should == expected_value2


    m2 = deepcopy(m1)

    m1[1,1].should == expected_value2
    m2[1,1].should == expected_value2

    m2[1,1] = expected_value

    m1[1,1].should == expected_value2
    m2[1,1].should == expected_value
  end

  it "should define transfer sign method" do
    transfer_sign(-1, 1).should == 1
    transfer_sign(1, 1).should == 1
    transfer_sign(1, -1).should == -1
    transfer_sign(-1, -1).should == -1
  end

  it "should compute hypotenuse without overflow or underflow" do
    pythag(0,0).should == 0
    pythag(1,0).should == 1
    pythag(0,1).should == 1
    pythag(0,1.0e308).should == 1.0e308
    pythag(1,1.0e-308).should == 1.0
  end
end

