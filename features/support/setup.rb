require_relative 'test_helper.rb'
require 'aruba/cucumber'
require 'minitest'
require 'retest'
require 'byebug'

module MinitestAssertionsBridge
  include Minitest::Assertions

  attr_accessor :assertions
end

Retest.logger = TestLogger.new

World(MinitestAssertionsBridge)

Before { self.assertions = 0 }

After do
  @listener&.stop
  Retest.logger&.clear
end
