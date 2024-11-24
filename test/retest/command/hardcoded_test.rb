require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class HardcodedTest < MiniTest::Test
      def setup
        @subject = Hardcoded.new(command: 'echo "hello world"')
      end

      include CommandInterface

      def test_test?
        refute Hardcoded.new(command: 'echo "hello world"').test_type?
        assert Hardcoded.new(command: 'echo <test>').test_type?
        refute Hardcoded.new(command: 'echo <changed>').test_type?
        assert Hardcoded.new(command: 'echo <changed> & <test>').test_type?
      end

      def test_variable?
        refute Hardcoded.new(command: 'echo "hello world"').variable_type?
        refute Hardcoded.new(command: 'echo <test>').variable_type?
        refute Hardcoded.new(command: 'echo <changed>').variable_type?
        assert Hardcoded.new(command: 'echo <changed> & <test>').variable_type?
      end

      def test_changed?
        refute Hardcoded.new(command: 'echo "hello world"').changed_type?
        refute Hardcoded.new(command: 'echo <test>').changed_type?
        assert Hardcoded.new(command: 'echo <changed>').changed_type?
        assert Hardcoded.new(command: 'echo <changed> & <test>').changed_type?
      end

      def test_hardcoded?
        assert Hardcoded.new(command: 'echo "hello world"').hardcoded_type?
        refute Hardcoded.new(command: 'echo <test>').hardcoded_type?
        refute Hardcoded.new(command: 'echo <changed>').hardcoded_type?
        refute Hardcoded.new(command: 'echo <changed> & <test>').hardcoded_type?
      end

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