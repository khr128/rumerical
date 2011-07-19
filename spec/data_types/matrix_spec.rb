require 'spec_helper'

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

  it "should define operation of addition" do
    m = Rumerical::Matrix.new @mi
    result = m + m
    result.should have_all_elements_within(1.0e-12).of(Rumerical::Matrix.new({1=>{1=>2}, 2=>{2=>4},3=>{3=>6}}))
  end

  it "should define operation of subtraction" do
    m = Rumerical::Matrix.new @mi
    result = m - m
    result.should have_all_elements_within(1.0e-12).of(Rumerical::Matrix.new({3=>{3=>0}}))
  end

  it "should multiply by a differently sized matrix" do
    m = Rumerical::Matrix.new({
      1=>{1=>1.0, 2=>1.5, 3=>1.8},
      2=>{1=>-1.1, 2=>2.5, 3=>2.8},
      3=>{1=>-11.1, 2=>12.5, 3=>-1.8}
    })
    s = Rumerical::Matrix.new({
      1=>{1=>-2.1535451557364222},
      2=>{1=>-1.6464861480669906},
      3=>{1=>3.124041321020504}
    })
    b = Rumerical::Matrix.new({
      1=>{1=>1},
      2=>{1=>7},
      3=>{1=>-2.3}
    })
    result = m*s
    result.should_not be_nil
    result.rect.should == Rumerical::Point.new(3,1)

    result.should have_all_elements_within(1.0e-12).of(b)
  end

  it "should define transposed matrix" do
    m = Rumerical::Matrix.new({
      1=>{1=>1.0, 2=>1.5},
      2=>{1=>-1.1, 2=>2.5},
      3=>{1=>-11.1, 2=>12.5}
    })
    mt = Rumerical::Matrix.new({
      1=>{1=>1.0, 2=>-1.1, 3=>-11.1},
      2=>{1=>1.5, 2=>2.5, 3=>12.5}
    })
    m.transpose.should have_all_elements_within(1.0e-12).of(mt)
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

  it "should swap elements" do
    m = Rumerical::Matrix.new @mi
    m[1,1].should == 1
    m[2,2].should == 2

    m.swap(1,1,2,2)

    m[1,1].should == 2
    m[2,2].should == 1
  end

  it "should swap rows" do
    m = Rumerical::Matrix.new @mi
    m[2,1].should == 0
    m[2,2].should == 2
    m[2,3].should == 0
    m[3,1].should == 0
    m[3,2].should == 0
    m[3,3].should == 3

    m.swap_rows(2,3)

    m[3,1].should == 0
    m[3,2].should == 2
    m[3,3].should == 0
    m[2,1].should == 0
    m[2,2].should == 0
    m[2,3].should == 3
  end

  it "should find pivot element" do
    m = Rumerical::Matrix.new @mi
    ipiv = Rumerical::Matrix.new({})
    m.find_pivot(ipiv) == [3,3]
  end

  it "should multiply column by value" do
    m = Rumerical::Matrix.new @mi
    m[2,1] = -1.3
    m[2,3] = 14.2

    m.multiply_column_by(3.0, 1)

    m[1,1].should be_within(1.0e-12).of(3)
    m[2,1].should be_within(1.0e-12).of(-3.9)
    m[3,1].should == 0
    m[2,2].should == 2
    m[2,3].should == 14.2
  end

  it "should multiply row by value" do
    m = Rumerical::Matrix.new @mi
    m[2,1] = -1.3
    m[2,3] = 14.2

    m.multiply_row_by(3.0, 2)

    m[2,1].should be_within(1.0e-12).of(-3.9)
    m[2,2].should == 6
    m[2,3].should be_within(1.0e-12).of(42.6)
  end

  it "should reduce a row by another row" do
    m = Rumerical::Matrix.new @mi
    m[2,1] = -1.3
    m[2,3] = 14.2
    m[3,1] = 3
    m[3,2] = 3

    m.reduce_row(3, 2, 2.0)

    m[3,1].should be_within(1.0e-12).of(5.6)
    m[3,2].should be_within(1.0e-12).of(-1)
    m[3,3].should be_within(1.0e-12).of(-25.4)

    m[2,1].should == -1.3
    m[2,2].should == 2
    m[2,3].should == 14.2
  end

  it "should find largest elements in rows" do
    m = Rumerical::Matrix.new @mi
    m[2,1] = -1.3
    m[2,3] = 14.2

    m.largest_element_in_row(2).should == 14.2
    m.largest_element_in_row(4).should == 0
  end

  it "should set columns from another matrix" do
    m = Rumerical::Matrix.new @mi
    m2 = Rumerical::Matrix.new({})
    m2.set_columns m, 2

    m2[1,2].should == 1
    m2[2,3].should == 2
    m2[3,4].should == 3
  end

end
