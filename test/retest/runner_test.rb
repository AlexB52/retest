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
        @subject = Runner.new(@command, stdout: StringIO.new)
      end

      def output
        @subject.stdout.string
      end

      def test_run
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb']) }

        assert_match "hello world", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "hello world", out
      end

      def test_sync_files
        sleep 3

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

      def test_initializes_last_command_correctly
        assert_equal "echo 'hello world'", @subject.last_command

        out, _ = capture_subprocess_io { @subject.run_last_command }

        assert_match "hello world", out
        assert_equal "\n", output
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

      def test_initializes_last_command_correctly
        assert_nil @subject.last_command

        out, _ = capture_subprocess_io { @subject.run_last_command }

        assert_equal '', out
        assert_equal(<<~EXPECTED, output)
          Error - Not enough information to run a command. Please trigger a run first.
        EXPECTED
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
        @subject.run

        assert_equal(<<~EXPECTED, output)
          FileNotFound - Retest could not find a changed file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run(changed_files: ['file_path.rb']) }

        assert_match "file_path.rb", out
      end

      def test_initializes_last_command_correctly
        assert_nil @subject.last_command

        out, _ = capture_subprocess_io { @subject.run_last_command }

        assert_equal '', out
        assert_equal(<<~EXPECTED, output)
          Error - Not enough information to run a command. Please trigger a run first.
        EXPECTED
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

      def test_initializes_last_command_correctly
        assert_nil @subject.last_command

        out, _ = capture_subprocess_io { @subject.run_last_command }

        assert_equal '', out
        assert_equal(<<~EXPECTED, output)
          Error - Not enough information to run a command. Please trigger a run first.
        EXPECTED
      end

      def test_run_multiple_tests
        assert_raises(Command::MultipleTestsNotSupported) do
          @subject.command = @command
          @subject.format_instruction(test_files: ['file_path.rb', 'file_path_two.rb'])
        end

        @subject.command = Command::Rails.new(all: false)
        instruction = @subject.format_instruction(test_files: ['file_path.rb', 'file_path_two.rb'])
        assert_equal 'bundle exec rails test file_path.rb file_path_two.rb', instruction
      end
    end
  end
end