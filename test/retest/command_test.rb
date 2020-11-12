require 'test_helper'

module Retest
  class CommandTest < MiniTest::Test
    module CommandInterfaceTest
      def test_behaviour
        assert_respond_to @subject, :==
        assert_respond_to @subject, :run
      end
    end

    def test_self_for
      assert_equal Command::HardcodedCommand.new('bundle exec rake test'), Command.for('bundle exec rake test')
      assert_equal Command::VariableCommand.new('bundle exec rake test TEST=<test>'), Command.for('bundle exec rake test TEST=<test>')
    end

    class HardcodedCommandTest < MiniTest::Test
      include CommandInterfaceTest

      def setup
        @subject = Command::HardcodedCommand.new("echo 'hello'")
      end

      def teardown
        Retest.logger.truncate(0)
        Retest.logger.rewind
      end

      def test_run
        @subject.run('file_path.rb')

        assert_equal "hello\n", Retest.logger.string
      end
    end

    class VariableCommandTest < MiniTest::Test
      include CommandInterfaceTest

      def setup
        @repository = Repository.new

        @subject = Command::VariableCommand.new("echo 'touch <test>'", repository: @repository)
      end

      def teardown
        Retest.logger.truncate(0)
        Retest.logger.rewind
      end

      def test_run_with_no_file_found
        @repository.files = []

        @subject.run('file_path.rb')

        assert_equal <<~EXPECTED, Retest.logger.string
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        @repository.files = ['file_path_test.rb']

        @subject.run('file_path.rb')

        assert_equal <<~EXPECTED, Retest.logger.string
          Test File Selected: file_path_test.rb
          touch file_path_test.rb
        EXPECTED
      end

      def test_returns_last_command
        @repository.files = ['file_path_test.rb']

        @subject.run('file_path.rb')

        assert_equal <<~EXPECTED, Retest.logger.string
          Test File Selected: file_path_test.rb
          touch file_path_test.rb
        EXPECTED

        @subject.run('unknown_path.rb')

        assert_equal <<~EXPECTED, Retest.logger.string
          Test File Selected: file_path_test.rb
          touch file_path_test.rb
          Test File Selected: file_path_test.rb
          touch file_path_test.rb
        EXPECTED
      end
    end
  end
end