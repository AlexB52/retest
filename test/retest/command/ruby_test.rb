require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class RubyTest < MiniTest::Test
      def setup
        @subject = Ruby.new(all: true, file_system: FakeFS.new([]))
      end

      include CommandInterface

      def test_type
        all_cmd = Ruby.new(all: true, file_system: FakeFS.new([]))
        assert all_cmd.test_type?
        refute all_cmd.variable_type?
        refute all_cmd.changed_type?
        refute all_cmd.hardcoded_type?

        cmd = Ruby.new(all: false, file_system: FakeFS.new([]))
        assert cmd.test_type?
        refute cmd.variable_type?
        refute cmd.changed_type?
        refute cmd.hardcoded_type?
      end

      def test_to_s
        assert_equal 'ruby <test>', Ruby.new(all: true, file_system: FakeFS.new(['bin/ruby'])).to_s
        assert_equal 'ruby <test>', Ruby.new(all: true, file_system: FakeFS.new([])).to_s
        assert_equal 'ruby <test>', Ruby.new(all: false, file_system: FakeFS.new(['bin/ruby'])).to_s
        assert_equal 'ruby <test>', Ruby.new(all: false, file_system: FakeFS.new([])).to_s

        assert_equal 'bundle exec ruby <test>', Ruby.new(all: true, file_system: FakeFS.new(['Gemfile.lock', 'bin/ruby'])).to_s
        assert_equal 'bundle exec ruby <test>', Ruby.new(all: true, file_system: FakeFS.new(['Gemfile.lock'])).to_s
        assert_equal 'bundle exec ruby <test>', Ruby.new(all: false, file_system: FakeFS.new(['Gemfile.lock', 'bin/ruby'])).to_s
        assert_equal 'bundle exec ruby <test>', Ruby.new(all: false, file_system: FakeFS.new(['Gemfile.lock'])).to_s
      end

      def test_format_with_one_file
        assert_equal %Q{-e "require './a/file/path.rb';"}, @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal %Q{-e "require './a/file/path.rb';require './another/file/path.rb';"}, @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end
    end
  end
end
