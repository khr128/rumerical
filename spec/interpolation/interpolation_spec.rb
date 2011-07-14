require 'spec_helper'

# Time to add your specs!
# http://rspec.info/
describe "Linear interpolation" do
  
  it "should interpolate between two points" do
    p1 = Rumerical::Point.new(1.0, 2.0)
    p2 = Rumerical::Point.new(2.0, 4.0)
    interpol = Rumerical::Interpolation::Linear.new(p1, p2)
    interpol.should_not be_nil

    ptest1 = Rumerical::Point.new(1.5, 3.0)
    ptest2 = Rumerical::Point.new(1.8, 3.6)
    interpol[ptest1.x].should == ptest1.y
    interpol[ptest2.x].should == ptest2.y

   #Different points 
    p1 = Rumerical::Point.new(1.0, 3.0)
    p2 = Rumerical::Point.new(2.0, 6.0)
    interpol = Rumerical::Interpolation::Linear.new(p1, p2)
    interpol.should_not be_nil

    ptest1 = Rumerical::Point.new(1.5, 4.5)
    ptest2 = Rumerical::Point.new(1.8, 5.4)
    interpol[ptest1.x].should == ptest1.y
    interpol[ptest2.x].should == ptest2.y
  end
  
end
