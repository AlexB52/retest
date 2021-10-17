require 'test_helper'
require_relative 'runner_interface'

module Retest
  module Runners
    class TestRunnerTest < MiniTest::Test
      def setup
        @subject = TestRunner.new("echo 'touch <test>'")
      end

      include RunnerInterfaceTest

      def test_run_with_no_file_found
        out, _ = capture_subprocess_io { @subject.run }

        assert_equal(<<~EXPECTED, out)
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        EXPECTED
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

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run('file_path_test.rb') }

        assert_match "touch file_path_test.rb", out
      end

      def test_returns_last_command
        out, _ = capture_subprocess_io { @subject.run('file_path_test.rb') }

        assert_match "touch file_path_test.rb", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "touch file_path_test.rb", out
      end

      def test_matching_unmatching?
        assert @subject.matching?
        refute @subject.unmatching?
      end
    end
  end
end