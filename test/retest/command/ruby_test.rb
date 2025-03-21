require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class RubyTest < Minitest::Test
      def setup
        @subject = Ruby.new(all: true, file_system: FakeFS.new([]))
      end

      include CommandInterface

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
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal %Q{-e "require './a/file/path.rb';require './another/file/path.rb';"}, @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end

      def test_switch_to
        all_command = Ruby.new(all: true, file_system: FakeFS.new([]))
        batched_command = Ruby.new(all: false, file_system: FakeFS.new([]))

        exception = assert_raises(Command::AllTestsNotSupported) { all_command.switch_to(:all) }
        assert_equal "All tests run not supported for Ruby command: 'ruby <test>'", exception.message
        assert_equal batched_command, all_command.switch_to(:batched)

        exception = assert_raises(Command::AllTestsNotSupported) { batched_command.switch_to(:all) }
        assert_equal "All tests run not supported for Ruby command: 'ruby <test>'", exception.message
        assert_equal batched_command, batched_command.switch_to(:batched)

        all_command = Ruby.new(all: true, file_system: FakeFS.new(['Gemfile.lock']))
        batched_command = Ruby.new(all: false, file_system: FakeFS.new(['Gemfile.lock']))

        exception = assert_raises(Command::AllTestsNotSupported) { all_command.switch_to(:all) }
        assert_equal "All tests run not supported for Ruby command: 'bundle exec ruby <test>'", exception.message
        assert_equal batched_command, all_command.switch_to(:batched)

        exception = assert_raises(Command::AllTestsNotSupported) { batched_command.switch_to(:all) }
        assert_equal "All tests run not supported for Ruby command: 'bundle exec ruby <test>'", exception.message
        assert_equal batched_command, batched_command.switch_to(:batched)
      end
    end

    class RubyWithACommandTest < Minitest::Test
      def setup
        @subject = Ruby.new(all: true, file_system: FakeFS.new([]), command: 'bin/test')
      end

      include CommandInterface

      def test_to_s
        assert_equal 'bin/test <test>', Ruby.new(command: 'bin/test <test>', all: true, file_system: FakeFS.new([])).to_s
        assert_equal 'bin/test <test>', Ruby.new(command: 'bin/test <test>', all: false, file_system: FakeFS.new([])).to_s
        assert_equal 'bin/test <test>', Ruby.new(command: 'bin/test <test>', all: true, file_system: FakeFS.new(['Gemfile.lock'])).to_s
        assert_equal 'bin/test <test>', Ruby.new(command: 'bin/test <test>', all: false, file_system: FakeFS.new(['Gemfile.lock'])).to_s
      end

      def test_format_with_one_file
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal %Q{-e "require './a/file/path.rb';require './another/file/path.rb';"}, @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end

      def test_switch_to
        batched_command = Ruby.new(command: 'bin/test <test>', file_system: FakeFS.new([]))

        assert_raises(Command::AllTestsNotSupported) { batched_command.switch_to(:all) }
        assert_equal batched_command, batched_command.switch_to(:batched)
      end
    end
  end
end
