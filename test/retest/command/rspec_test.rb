require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class RspecTest < MiniTest::Test
      def setup
        @subject = Rspec.new(all: true, file_system: FakeFS.new([]))
      end

      include CommandInterface

      def test_to_s
        assert_equal 'bin/rspec',                Rspec.new(all: true, file_system: FakeFS.new(['bin/rspec'])).to_s
        assert_equal 'bundle exec rspec',        Rspec.new(all: true, file_system: FakeFS.new([])).to_s
        assert_equal 'bin/rspec <test>',         Rspec.new(all: false, file_system: FakeFS.new(['bin/rspec'])).to_s
        assert_equal 'bundle exec rspec <test>', Rspec.new(all: false, file_system: FakeFS.new([])).to_s
        # take into account gem repository which doesn't have a bin/rspec file
        assert_equal 'bundle exec rspec <test>', Rspec.new(all: false).to_s
        assert_equal 'bundle exec rspec',        Rspec.new(all: true).to_s
      end

      def test_format_with_one_file
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal 'a/file/path.rb another/file/path.rb', @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end
    end
  end
end
