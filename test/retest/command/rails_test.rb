require 'test_helper'

module Retest
  class Command
    class RailsTest < MiniTest::Test
      def setup
        @subject = Rails.new(all: true, file_system: FakeFS.new([]))
      end

      def test_interface
        assert_respond_to @subject, :run_all
        assert_respond_to @subject, :command
      end

      def test_command
        assert_equal 'bin/rails test',                Rails.new(all: true, file_system: FakeFS.new(['bin/rails'])).command
        assert_equal 'bundle exec rails test',        Rails.new(all: true, file_system: FakeFS.new([])).command
        assert_equal 'bin/rails test <test>',         Rails.new(all: false, file_system: FakeFS.new(['bin/rails'])).command
        assert_equal 'bundle exec rails test <test>', Rails.new(all: false, file_system: FakeFS.new([])).command
        # take into account gem repository which doesn't have a bin file
        assert_equal 'bundle exec rails test <test>', Rails.new(all: false).command
        assert_equal 'bundle exec rails test',        Rails.new(all: true).command
      end

      def test_run_one_file
        mock = Minitest::Mock.new
        mock.expect :run, true, ['a/file/path.rb']

        @subject.run_all('a/file/path.rb', runner: mock)

        mock.verify
      end

      def test_run_multiple_files
        mock = Minitest::Mock.new
        mock.expect :run, true, ['a/file/path.rb another/file/path.rb']

        @subject.run_all('a/file/path.rb', 'another/file/path.rb', runner: mock)

        mock.verify
      end
    end
  end
end