begin
  require 'rspec'
  require 'rubygems'
  require 'ruby-debug19'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rumerical'
require 'custom_matchers/matrix_matchers'

RSpec.configure do |config|
  config.include(MatrixMatchers)
end

