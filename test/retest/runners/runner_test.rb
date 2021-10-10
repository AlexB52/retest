require 'test_helper'
require_relative 'runner_interface'

module Retest
  module Runners
    class RunnerTest < MiniTest::Test
      def setup
        @subject = Runner.new("echo 'hell world'")
      end

      include RunnerInterfaceTest
    end
  end
end