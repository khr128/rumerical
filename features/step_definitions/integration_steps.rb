Given /^an integration object with the following parameters:$/ do |table|
  row = table.hashes[0]
  f = lambda{|x| eval(row["func"])}
  @integrator = Rumerical::Integration::Integrator.new(row["a"].to_f, row["b"].to_f, f)
end

Then /^I apply extended trapezoid rule successively with the following results:$/ do |table|
  table.hashes.each do |row|
    @integrator.trapzd(row["n"].to_i).should be_within(row["eps"].to_f).of(row["integral"].to_f)
  end
end
