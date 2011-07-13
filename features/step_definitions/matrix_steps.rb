require './lib/rumerical'
Given /^matrix with the following elements:$/ do |table|
  mi = {}
  table.hashes.each do |row|

  end
  @matrix = Rumerical::Matrix.new mi
end

