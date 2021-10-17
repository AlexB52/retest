require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class RakeTest < MiniTest::Test
      def setup
        @subject = Rake.new(all: true, file_system: FakeFS.new([]))
      end

      include CommandInterface

      def test_to_s
        assert_equal 'bin/rake test',                     Rake.new(all: true, file_system: FakeFS.new(['bin/rake'])).to_s
        assert_equal 'bundle exec rake test',             Rake.new(all: true, file_system: FakeFS.new([])).to_s
        assert_equal 'bin/rake test TEST=<test>',         Rake.new(all: false, file_system: FakeFS.new(['bin/rake'])).to_s
        assert_equal 'bundle exec rake test TEST=<test>', Rake.new(all: false, file_system: FakeFS.new([])).to_s
        # take into account gem repository which doesn't have a bin file
        assert_equal 'bundle exec rake test TEST=<test>', Rake.new(all: false).to_s
        assert_equal 'bundle exec rake test',             Rake.new(all: true).to_s
      end

      def test_format_with_one_file
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal '"{a/file/path.rb,another/file/path.rb}"', @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end

    end
  end
end
