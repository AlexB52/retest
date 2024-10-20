require 'test_helper'
require_relative 'runner_interface'
require_relative 'observable_runner'

module Retest
  module Runners
    class RunnerInterfaceTests < MiniTest::Test
      def setup
        @subject = Runner.new("echo 'hello world'")
      end

      include RunnerInterfaceTest
      include OversableRunnerTests

      private

      def observable_act(subject)
        subject.run
      end
    end

    class RunnerTest < MiniTest::Test
      def setup
        @subject = Runner.new("echo 'hello world'")
      end

      def test_run
        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "hello world", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "hello world", out
      end

      def test_run_all_tests
        assert_raises(NotSupportedError) { @subject.run_all_tests('file_path.rb file_path_two.rb') }
      end
    end
  end
end