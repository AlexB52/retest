require 'test_helper'
require_relative 'runner_interface'

module Retest
  module Runners
    class HardcodedRunnerTest < MiniTest::Test
      def setup
        @subject = HardcodedRunner.new("echo 'hell world'")
      end

      include RunnerInterfaceTest
    end
  end
end