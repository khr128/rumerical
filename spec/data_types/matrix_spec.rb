require 'spec_helper.rb'

describe "Matrix" do
  before :each do
    @mi = {
      1 => {1 => 1},
      2 => {2 => 2},
      3 => {3 => 3}
    }
  end

  it "should have all zero elements when intialized with nothing" do
    m = Rumerical::Matrix.new({})
    m[1,1].should == 0
    m.rect.should == Rumerical::Point.new(0,0)
  end
  
  it "should be initialized" do
    m = Rumerical::Matrix.new @mi
    m[1,1].should == 1
    m[2,2].should == 2
    m[3,3].should == 3
    m[1,3].should == 0

    m.rect.should == Rumerical::Point.new(3,3)
  end

  it "should define the operation of multiplication" do
    m = Rumerical::Matrix.new @mi
    result = m*m
    result.should_not be_nil
    result.rect.should == Rumerical::Point.new(3,3)

    result[1,1].should == 1
    result[2,2].should == 4
    result[3,3].should == 9
    result[1,3].should == 0
    result[2,3].should == 0
    result[1,2].should == 0
    result[2,1].should == 0
    result[3,1].should == 0
    result[3,2].should == 0
  end

  it "should define identity matrix" do
    i = Rumerical::Matrix.identity(3)
    i[1,1].should == 1
    i[2,2].should == 1
    i[3,3].should == 1
    i[1,3].should == 0
    i[2,3].should == 0
    i[1,2].should == 0
    i[2,1].should == 0
    i[3,1].should == 0
    i[3,2].should == 0
  end
end

