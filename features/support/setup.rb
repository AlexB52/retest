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

Dir.mkdir('tmp') unless Dir.exists?('tmp')
File.open 'tmp/output.log', 'w+'

Before do
  self.assertions = 0
end

After do
  clear_output
  if @pid
    Process.kill('SIGHUP', @pid)
    Process.detach(@pid)
  end
end
