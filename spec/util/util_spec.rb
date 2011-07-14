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
end

