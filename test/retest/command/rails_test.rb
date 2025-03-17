require 'test_helper'
require_relative 'command_interface'

module Retest
  class Command
    class RailsTest < Minitest::Test
      def setup
        @subject = Rails.new(all: true, file_system: FakeFS.new([]))
      end

      include CommandInterface

      def test_to_s
        assert_equal 'bin/rails test',                Rails.new(all: true, file_system: FakeFS.new(['bin/rails'])).to_s
        assert_equal 'bundle exec rails test',        Rails.new(all: true, file_system: FakeFS.new([])).to_s
        assert_equal 'bin/rails test <test>',         Rails.new(all: false, file_system: FakeFS.new(['bin/rails'])).to_s
        assert_equal 'bundle exec rails test <test>', Rails.new(all: false, file_system: FakeFS.new([])).to_s
        # take into account gem repository which doesn't have a bin file
        assert_equal 'bundle exec rails test <test>', Rails.new(all: false).to_s
        assert_equal 'bundle exec rails test',        Rails.new(all: true).to_s
      end

      def test_format_with_one_file
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal 'a/file/path.rb another/file/path.rb', @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end

      def test_switch_to
        all_command = Rails.new(all: true, file_system: FakeFS.new([]))
        batched_command = Rails.new(all: false, file_system: FakeFS.new([]))

        assert_equal all_command, all_command.switch_to(:all)
        assert_equal batched_command, all_command.switch_to(:batched)

        assert_equal all_command, batched_command.switch_to(:all)
        assert_equal batched_command, batched_command.switch_to(:batched)
      end
    end

    class RailsWithACommandTest < Minitest::Test
      def setup
        @subject = Rails.new(command: 'bin/test', file_system: nil)
      end

      include CommandInterface

      def test_to_s
        assert_equal 'bin/test',        Rails.new(command: 'bin/test', file_system: FakeFS.new(['bin/rails'])).to_s
        assert_equal 'bin/test',        Rails.new(command: 'bin/test', file_system: FakeFS.new([])).to_s

        assert_equal 'bin/test <test>', Rails.new(command: 'bin/test <test>', file_system: FakeFS.new(['bin/rails'])).to_s
        assert_equal 'bin/test <test>', Rails.new(command: 'bin/test <test>', file_system: FakeFS.new([])).to_s
      end

      def test_format_with_one_file
        assert_equal 'a/file/path.rb', @subject.format_batch('a/file/path.rb')
      end

      def test_format_with_multiple_files
        assert_equal 'a/file/path.rb another/file/path.rb', @subject.format_batch('a/file/path.rb', 'another/file/path.rb')
      end

      def test_switch_to
        batched_command = Rails.new(command: 'bin/test <test>')
        all_command = Rails.new(command: 'bin/test')

        assert_equal all_command, all_command.switch_to(:all)
        assert_equal batched_command, all_command.switch_to(:batched)

        assert_equal all_command, batched_command.switch_to(:all)
        assert_equal batched_command, batched_command.switch_to(:batched)
      end
    end
  end
end