require './lib/rumerical'
def initial_matrix table
  mi = {}
  table.hashes.each do |row|
    unless mi[row["i"].to_i]
      mi[row["i"].to_i] = {row["j"].to_i => row["value"].to_f}
    else
      mi[row["i"].to_i][row["j"].to_i] = row["value"].to_f
    end
  end
  puts mi.inspect
  mi
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
  table.hashes.each do |row| 
    @matrix[row["i"].to_i,row["j"].to_i].should == row["value"].to_f
  end
end

Then /^the matrix "([^"]*)" has the folowing elements:$/ do |name, table|
  m = instance_variable_get("@matrix_#{name}")
  table.hashes.each do |row| 
    m[row["i"].to_i,row["j"].to_i].should == row["value"].to_f
  end
end
