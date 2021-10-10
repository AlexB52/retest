require 'test_helper'
require_relative 'runner_interface'

module Retest
  module Runners
    class HardcodedRunnerTest < MiniTest::Test
      def setup
        @subject = HardcodedRunner.new("echo 'hello world'")
      end

      include RunnerInterfaceTest

      def test_run
        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "hello world", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "hello world", out
      end

      def test_matching_unmatching?
        refute @subject.matching?
        assert @subject.unmatching?
      end
    end
  end
end