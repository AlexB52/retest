require_relative 'test_helper.rb'
require 'aruba/cucumber'
require 'minitest'
require 'retest'
require 'byebug'

module MinitestAssertionsBridge
  include Minitest::Assertions

  attr_accessor :assertions
end

World(MinitestAssertionsBridge)

Before do
  self.assertions = 0
end

After do
  @file&.delete
  if @pid
    Process.kill('SIGHUP', @pid)
    Process.detach(@pid)
  end
end
