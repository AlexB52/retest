require 'test_helper'
require_relative 'runner_interface'
require_relative 'observable_runner'

module Retest
  module Runners
    class RunnerTest < MiniTest::Test
      def setup
        @subject = Runner.new("echo 'hello world'")
      end

      include RunnerInterfaceTest
      include OversableRunnerTests

      def test_run
        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "hello world", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "hello world", out
      end

      def test_run_all_tests
        runner = Runner.new("echo '<test>'")

        out, _ = capture_subprocess_io { runner.run_all_tests('file_path.rb file_path_two.rb') }

        assert_equal <<~EXPECATIONS, out
        Test File Selected: file_path.rb file_path_two.rb
        file_path.rb file_path_two.rb
        EXPECATIONS
      end

      private

      def observable_act(subject)
        subject.run
      end
    end
  end
end