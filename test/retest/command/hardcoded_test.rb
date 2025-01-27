require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class HardcodedTest < MiniTest::Test
      include CommandInterface

      def setup
        @subject = Hardcoded.new(all: false, command: 'echo "hello world"')
      end

      def test_a_hardcoded_command_status
        command = Hardcoded.new(command: 'echo "hello world"')
        refute command.has_test?
        refute command.has_changed?
      end

      def test_a_test_and_changed_command_status
        command = Hardcoded.new(command: 'echo <test> & <changed>')
        assert command.has_test?
        assert command.has_changed?
      end

      def test_a_test_command_status
        command = Hardcoded.new(command: 'echo <test>')
        assert command.has_test?
        refute command.has_changed?
      end

      def test_a_changed_command_status
        command = Hardcoded.new(command: 'echo <changed>')
        refute command.has_test?
        assert command.has_changed?
      end

      def test_to_s
        assert_equal 'echo "hello world"', @subject.to_s
      end

      def test_format_with_one_file
        assert_raises(Command::MultipleTestsNotSupported) do
          @subject.format_batch('a/file/path.rb')
        end
      end

      def test_format_with_multiple_files
        assert_raises(Command::MultipleTestsNotSupported) do
          @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
        end
      end

      def test_switch_to
        all_command = Hardcoded.new(all: true, command: 'echo "hello world"')
        batched_command = Hardcoded.new(all: false, command: 'echo "hello world"')

        assert_equal all_command, all_command.switch_to(:all)
        assert_equal all_command, batched_command.switch_to(:all)

        assert_equal batched_command, all_command.switch_to(:batched)
        assert_equal batched_command, batched_command.switch_to(:batched)
      end
    end
  end
end