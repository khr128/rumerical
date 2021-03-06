$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Rumerical
  VERSION = '0.0.3'
end

require 'util/util'
require 'linear_algebra'
require 'data_types'
require 'interpolation/interpolation'
require 'integration/integration'
