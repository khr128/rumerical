require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Point" do
  before :each do
    @expected_x = 42.0
    @expected_y = 37.0
  end

  it "should be initialized" do

    p = Rumerical::Point.new(@expected_x, @expected_y)
    p.should_not be_nil

    p.x.should == @expected_x
    p.y.should == @expected_y

  end

  it "should define equality by value" do
    p1 = Rumerical::Point.new(@expected_x, @expected_y)
    p2 = Rumerical::Point.new(@expected_x, @expected_y)

    p3 = Rumerical::Point.new(@expected_x+1, @expected_y)
    p4 = Rumerical::Point.new(@expected_x, @expected_y+1)

    (p1 == p2).should be_true
    (p1.eql?(p2)).should be_true

    (p1 == p3).should be_false
    (p1 == p4).should be_false

    (p1 != p3).should be_true
    (p1 != p4).should be_true
  end

end
