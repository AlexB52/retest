require 'test_helper'
require_relative 'runner_interface'

module Retest
  module Runners
    class VariableRunnerTest < MiniTest::Test
      def setup
        @subject = VariableRunner.new("echo 'hell world'")
      end

      include RunnerInterfaceTest
    end
  end
end