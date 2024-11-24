require 'test_helper'
require_relative 'runner/runner_interface'
require_relative 'runner/observable_runner'

module Retest
  class Runner
    class RunnerInterfaceTests < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo 'hello world'")
        @subject = Runner.new(@command)
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
        @command = Command::Hardcoded.new(command: "echo 'hello world'")
        @subject = Runner.new(@command)
      end

      def test_run
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb']) }

        assert_match "hello world", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "hello world", out
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
    end

    class VariableRunnerTest < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo '<changed> & <test>'")
        @subject = Runner.new(@command, stdout: StringIO.new)
      end

      def output
        @subject.stdout.string
      end

      def test_files_selected_ouptut
        _, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb'], test_files: ['file_path_test.rb']) }

        assert_equal(<<~EXPECTED, output)
          Changed file: file_path.rb
          Test file: file_path_test.rb

        EXPECTED
      end

      def test_run_with_no_match
        _, _ = capture_subprocess_io { @subject.run(changed_files: ['another_file_path.rb'], test_files: [nil]) }

        assert_equal(<<~EXPECTED, output)
          Changed file: another_file_path.rb
          FileNotFound - Retest could not find a matching test file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb'], test_files: ['file_path_test.rb']) }

        assert_match "file_path.rb & file_path_test.rb", out
      end

      def test_returns_last_command
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb'], test_files: ['file_path_test.rb']) }

        assert_match "file_path.rb & file_path_test.rb", out

        out, _ = capture_subprocess_io { @subject.run(changed_files: ['another_file_path.rb'], test_files: ['file_path_test.rb']) }

        assert_match "another_file_path.rb & file_path_test.rb", out
      end
    end

    class ChangeRunnerTest < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo '<changed>'")
        @subject = Runner.new(@command, stdout: StringIO.new)
      end

      def output
        @subject.stdout.string
      end

      def test_run_with_no_file_found
        _, _ = capture_subprocess_io { @subject.run }

        assert_equal(<<~EXPECTED, output)
          FileNotFound - Retest could not find a changed file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb']) }

        assert_match "file_path.rb", out
      end
    end

    class TestRunnerTest < MiniTest::Test
      def setup
        @command = Command::Hardcoded.new(command: "echo 'touch <test>'")
        @subject = Runner.new(@command, stdout: StringIO.new)
      end

      def output
        @subject.stdout.string
      end

      def test_run_with_no_file_found
        _, _ = capture_subprocess_io { @subject.run(changed_files: [nil], test_files: [nil]) }

        assert_equal(<<~EXPECTED, output)
          FileNotFound - Retest could not find a matching test file to run.
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