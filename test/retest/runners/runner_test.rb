require 'test_helper'
require_relative 'runner_interface'

module Retest
  module Runners
    class RunnerTest < MiniTest::Test
      def setup
        @subject = Runner.new("echo 'hell world'")
      end

      include RunnerInterfaceTest

      def test_matching
        refute @subject.matching?
        assert @subject.unmatching?
      end
    end
  end
end