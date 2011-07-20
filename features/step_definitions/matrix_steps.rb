require './lib/rumerical'
require './spec/custom_matchers/matrix_matchers'
include MatrixMatchers

def initial_matrix table
  mi = {}
  table.hashes.each do |row|
    unless mi[row["i"].to_i]
      mi[row["i"].to_i] = {row["j"].to_i => row["value"].to_f}
    else
      mi[row["i"].to_i][row["j"].to_i] = row["value"].to_f
    end
  end
  mi
end

def verify_matrix m, table
  table.hashes.each do |row| 
    m[row["i"].to_i,row["j"].to_i].should == row["value"].to_f
  end
end

Given /^matrix is initialized with the following elements:$/ do |table|
  @matrix = Rumerical::Matrix.new(initial_matrix table)
end

Given /^matrix "([^"]*)" is initialized with the following elements:$/ do |name, table|
  instance_variable_set("@matrix_#{name}", Rumerical::Matrix.new(initial_matrix table))
end

When /^I multiply the matrix and the matrix "([^"]*)"$/ do |name|
  @matrix_result = @matrix*instance_variable_get("@matrix_#{name}")
end

Then /^the matrix has the following elements:$/ do |table|
  verify_matrix @matrix, table
end

Then /^the matrix "([^"]*)" has the folowing elements:$/ do |name, table|
  verify_matrix instance_variable_get("@matrix_#{name}"), table
end

Then /^I apply Gauss\-Jordan elimination on matrix with matrix of "([^"]*)"$/ do |name|
  @matrix.gaussj instance_variable_get("@matrix_#{name}")
end

Then /^I have inverse matrix for the matrix$/ do
  @matrix.inverse.should_not be_nil
  i = Rumerical::Matrix.identity(@matrix.rect.x)
  (@matrix*@matrix.inverse).should have_all_elements_within(1.0e-12).of(i)
end

Then /^I have solutions for the "([^"]*)"$/ do |name|
  @matrix.solutions.should_not be_nil
  right_parts = instance_variable_get("@matrix_#{name}")
  (@matrix*@matrix.solutions).should have_all_elements_within(1.0e-12).of(right_parts)
end

When /^I perform LU decomposition of the matrix$/ do
  @matrix.ludcmp
end

Then /^I have L and U matrices defined for the matrix$/ do
  @matrix.l_matrix.should_not be_nil  
  @matrix.u_matrix.should_not be_nil  
  prod = @matrix.l_matrix*@matrix.u_matrix
  @matrix.lu_unscramble prod
  prod.should have_all_elements_within(1.0e-12).of(@matrix)
end

When /^I perform LU back substitution with "([^"]*)"$/ do |name|
  right_parts = instance_variable_get("@matrix_#{name}")
  @matrix.lubksb right_parts
end

When /^I perform LU matrix inversion$/ do
  @matrix.luinv
end

When /^I perform singular value decomposition of the matrix$/ do
  @matrix.svdcmp
end

Then /^I have singular value decomposition of the matrix$/ do
  @matrix.svd_u.should_not be_nil
  @matrix.svd_v.should_not be_nil
  @matrix.svd_w.should_not be_nil

  @matrix.svd_u.rect.should == @matrix.rect
  col_n = @matrix.svd_u.rect.col
  smaller_n = [col_n, @matrix.svd_u.rect.row].min
  larger_n = [col_n, @matrix.svd_u.rect.row].max
  @matrix.svd_v.rect.col.should == col_n
  @matrix.svd_v.rect.row.should == col_n

  i = Rumerical::Matrix.identity(smaller_n)

  prod_u = @matrix.svd_u.transpose*@matrix.svd_u
  prod_u.rect.col = smaller_n
  prod_u.rect.row = smaller_n
  prod_u.should have_all_elements_within(1.0e-12).of(i)

  (smaller_n+1..larger_n).each do |i|
    (1..col_n).each do |j|
      prod_u[i,j].should == 0
    end
  end

  i = Rumerical::Matrix.identity(col_n)
  vt = @matrix.svd_v.transpose
  (vt*@matrix.svd_v).should have_all_elements_within(1.0e-12).of(i)

  (1..col_n).each do |col|
    vt.multiply_row_by  @matrix.svd_w[col,1], col
  end
  (@matrix.svd_u*vt).should have_all_elements_within(1.0e-12).of(@matrix)
end
