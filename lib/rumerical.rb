$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Rumerical
  VERSION = '0.0.1'
end

require 'data_types/point'
require 'data_types/matrix'
require 'interpolation/linear'
