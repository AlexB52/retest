require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class HardcodedTest < MiniTest::Test
      def setup
        @subject = Hardcoded.new(command: 'echo "hello world"')
      end

      include CommandInterface

      def test_to_s
        assert_equal 'echo "hello world"', @subject.to_s
      end

      def test_format_with_one_file
        assert_nil @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_nil @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end
    end
  end
end