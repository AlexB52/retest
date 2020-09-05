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
        @subject = Command::VariableCommand.new(
          "echo '<test>'",
          repository: Repository.new(files: [])
        )
      end

      def test_run_with_no_file_found
        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "Could not find a file test matching", out
      end

      def test_run_with_a_file_found
        @subject = Command::VariableCommand.new(
          "echo 'touch <test>'",
          repository: Repository.new(files: ['file_path_test.rb'])
        )

        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "touch file_path_test.rb", out
      end
    end
  end
end