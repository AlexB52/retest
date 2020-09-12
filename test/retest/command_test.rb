require 'test_helper'

module Retest
  class CommandTest < MiniTest::Test
    module CommandBehaviourTest
      def test_behaviour
        assert_respond_to @subject, :==
        assert_respond_to @subject, :run
      end
    end

    def test_self_for
      assert_equal Command::HardcodedCommand.new('bundle exec rake test'), Command.for('bundle exec rake test')
      assert_equal Command::VariableCommand.new('bundle exec rake test TEST=<test>'), Command.for('bundle exec rake test TEST=<test>')
    end

    class HardcodedCommand < MiniTest::Test
      include CommandBehaviourTest

      def setup
        @subject = Command::HardcodedCommand.new("echo 'hello'")
      end

      def test_run
        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "hello", out
      end
    end

    class VariableCommand < MiniTest::Test
      include CommandBehaviourTest

      def setup
        @repository = Repository.new

        @subject = Command::VariableCommand.new("echo 'touch <test>'", repository: @repository)
      end

      def test_run_with_no_file_found
        @repository.files = []

        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_equal <<~EXPECTED, out
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        @repository.files = ['file_path_test.rb']

        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "touch file_path_test.rb", out
      end

      def test_last_command
        @repository.files = ['file_path_test.rb']

        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "touch file_path_test.rb", out

        out, _ = capture_subprocess_io { @subject.run('unknown_path.rb') }

        assert_match "touch file_path_test.rb", out
      end
    end
  end
end