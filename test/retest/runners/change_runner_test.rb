require 'test_helper'
require_relative 'runner_interface'
require_relative 'observable_runner'

module Retest
  module Runners
    class ChangeRunnerInterfaceTests < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo 'touch <changed>'")
        @subject = ChangeRunner.new(@command)
      end

      include RunnerInterfaceTest
      include OversableRunnerTests

      private

      def observable_act(subject)
        subject.run(changed_files: ['file_path.rb'])
      end
    end

    class ChangeRunnerTest < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo 'touch <changed>'")
        @subject = ChangeRunner.new(@command, stdout: StringIO.new)
      end

      def output
        @subject.stdout.string
      end

      def test_run_with_no_file_found
        _, _ = capture_subprocess_io { @subject.run }

        assert_equal(<<~EXPECTED, output)
          404 - File Not Found
          Retest could not find a changed file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb']) }

        assert_match "touch file_path.rb", out
      end

      def test_run_all_tests
        assert_raises(NotSupportedError) { @subject.run_all_tests('file_path.rb file_path_two.rb') }
      end
    end
  end
end