require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Matrix" do
  it "should be initialized" do
    mi = {
      1 => {1 => 1},
      2 => {2 => 2},
      3 => {3 => 3}
    }
    m = Rumerical::Matrix.new mi
    m[1,1].should == 1
    m[2,2].should == 2
    m[3,3].should == 3
    m[1,3].should == 0
  end
end

