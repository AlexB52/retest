require 'test_helper'
require_relative 'runner_interface'
require_relative 'observable_runner'

module Retest
  module Runners
    class TestRunnerInterfaceTests < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo 'touch <test>'")
        @subject = TestRunner.new(@command)
      end

      include RunnerInterfaceTest
      include OversableRunnerTests

      private

      def observable_act(subject)
        subject.run(changed_files: ['file_path.rb'], test_files: ['file_path_test.rb'])
      end
    end

    class TestRunnerTest < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo 'touch <test>'")
        @subject = TestRunner.new(@command, stdout: StringIO.new)
      end

      def output
        @subject.stdout.string
      end

      def test_run_with_no_file_found
        _, _ = capture_subprocess_io { @subject.run(changed_files: [nil], test_files: [nil]) }

        assert_equal(<<~EXPECTED, output)
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb'], test_files: ['file_path_test.rb']) }

        assert_match "touch file_path_test.rb", out
      end

      def test_returns_last_command
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb'], test_files: ['file_path_test.rb']) }

        assert_match "touch file_path_test.rb", out

        out, _ = capture_subprocess_io { @subject.run(changed_files: ['some-weird-path.rb'], test_files: ['file_path_test.rb']) }

        assert_match "touch file_path_test.rb", out
      end

      def test_sync_files
        @subject.cached_test_file = 'file_path_test.rb'

        @subject.sync(added: [], removed:['something.rb'])
        assert_equal 'file_path_test.rb', @subject.cached_test_file

        @subject.sync(added: nil, removed:'something.rb')
        assert_equal 'file_path_test.rb', @subject.cached_test_file

        @subject.sync(added: ['a.rb'], removed:['file_path_test.rb'])
        assert_nil @subject.cached_test_file

        @subject.cached_test_file = 'file_path_test.rb'
        @subject.sync(added: 'a.rb', removed:'file_path_test.rb')
        assert_nil @subject.cached_test_file
      end

      def test_run_all_tests
        out, _ = capture_subprocess_io { @subject.run_all_tests('file_path.rb file_path_two.rb') }

        assert_equal(<<~EXPECATIONS, @subject.stdout.string)
          Test Files Selected: file_path.rb file_path_two.rb
        EXPECATIONS

        assert_equal(<<~EXPECATIONS, out)
          touch file_path.rb file_path_two.rb
        EXPECATIONS
      end
    end
  end
end