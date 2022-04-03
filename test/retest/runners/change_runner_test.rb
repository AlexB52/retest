require 'test_helper'
require_relative 'runner_interface'
require_relative 'observable_runner'

module Retest
  module Runners
    class ChangeRunnerTest < MiniTest::Test
      def setup
        @subject = ChangeRunner.new("echo 'touch <changed>'")
      end

      include RunnerInterfaceTest
      include OversableRunnerTests

      def test_run_with_no_file_found
        out, _ = capture_subprocess_io { @subject.run }

        assert_equal(<<~EXPECTED, out)
          404 - Test File Not Found
          Retest could not find a changed file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "touch file_path.rb", out
      end

      private

      def observable_act(subject)
        subject.run('file_path.rb')
      end
    end
  end
end