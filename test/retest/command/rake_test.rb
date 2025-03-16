require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class RakeTest < Minitest::Test
      def setup
        @subject = Rake.new(all: true, file_system: FakeFS.new([]))
      end

      include CommandInterface

      def test_to_s
        assert_equal 'bin/rake test',                     Rake.new(all: true, file_system: FakeFS.new(['bin/rake'])).to_s
        assert_equal 'bundle exec rake test',             Rake.new(all: true, file_system: FakeFS.new([])).to_s
        assert_equal 'bin/rake test TEST=<test>',         Rake.new(all: false, file_system: FakeFS.new(['bin/rake'])).to_s
        assert_equal 'bundle exec rake test TEST=<test>', Rake.new(all: false, file_system: FakeFS.new([])).to_s
      end

      def test_format_with_one_file
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal '"{a/file/path.rb,another/file/path.rb}"', @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end

      def test_switch_to
        all_command = Rake.new(all: true, file_system: FakeFS.new([]))
        batched_command = Rake.new(all: false, file_system: FakeFS.new([]))

        assert_equal all_command, all_command.switch_to(:all)
        assert_equal batched_command, all_command.switch_to(:batched)

        assert_equal all_command, batched_command.switch_to(:all)
        assert_equal batched_command, batched_command.switch_to(:batched)
      end
    end

    class RakeWithACommandTest < Minitest::Test
      def setup
        @subject = Rake.new(command: 'bin/test', all: true, file_system: FakeFS.new([]))
      end

      include CommandInterface

      def test_to_s
        assert_equal 'bin/test',             Rake.new(command: 'bin/test', file_system: FakeFS.new(['bin/rake'])).to_s
        assert_equal 'bin/test TEST=<test>', Rake.new(command: 'bin/test TEST=<test>', file_system: FakeFS.new(['bin/rake'])).to_s
        assert_equal 'bin/test',             Rake.new(command: 'bin/test', file_system: FakeFS.new([])).to_s
        assert_equal 'bin/test TEST=<test>', Rake.new(command: 'bin/test TEST=<test>', file_system: FakeFS.new([])).to_s
      end

      def test_format_with_one_file
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal '"{a/file/path.rb,another/file/path.rb}"', @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end

      def test_switch_to
        all_command = Rake.new(command: 'bin/test', file_system: nil)
        batched_command = Rake.new(command: 'bin/test TEST=<test>', file_system: nil)

        assert_equal all_command, all_command.switch_to(:all)
        assert_equal batched_command, all_command.switch_to(:batched)

        assert_equal all_command, batched_command.switch_to(:all)
        assert_equal batched_command, batched_command.switch_to(:batched)
      end
    end
  end
end
