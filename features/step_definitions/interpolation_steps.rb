Given /^an interpolation object$/ do
  @interpolator = Rumerical::Interpolation::Interpolator.new
end

When /^I set interpolation points to:$/ do |table|
  table.hashes.each do |row|
    @interpolator.x << row["x"].to_f
    @interpolator.y << row["y"].to_f
  end
end

Then /^I should get the following interpolated values using polinomial interpolation:$/ do |table|
  table.hashes.each do |row|
    order = row["order"].to_i
    offset = row["offset"].to_i
    x = row["x"].to_f
    y = row["y"].to_f
    eps = row["eps"].to_f

    @interpolator.polint(x, offset, order).should be_within(eps).of(y)
 end
end
