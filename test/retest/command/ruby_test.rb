require 'test_helper'

module Retest
  class Command
    class RubyTest < MiniTest::Test
      def setup
        @subject = Ruby.new(all: true, file_system: FakeFS.new([]))
      end

      def test_interface
        assert_respond_to @subject, :run_all
        assert_respond_to @subject, :to_s
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

      def test_run_one_file
        mock = Minitest::Mock.new
        mock.expect :run, true, [%Q{-e "require './a/file/path.rb';"}]
        @subject.run_all('a/file/path.rb', runner: mock)

        mock.verify
      end

      def test_run_multiple_files
        mock = Minitest::Mock.new
        mock.expect :run, true, [%Q{-e "require './a/file/path.rb';require './another/file/path.rb';"}]

        @subject.run_all('a/file/path.rb', 'another/file/path.rb', runner: mock)

        mock.verify
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
