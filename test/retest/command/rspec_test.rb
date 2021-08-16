require 'test_helper'

module Retest
  class Command
    class RspecTest < MiniTest::Test
      def setup
        @subject = Rspec.new(all: true, file_system: FakeFS.new([]))
      end

      def test_interface
        assert_respond_to @subject, :run_all
        assert_respond_to @subject, :to_s
      end

      def test_to_s
        assert_equal 'bin/rspec',                Rspec.new(all: true, file_system: FakeFS.new(['bin/rspec'])).to_s
        assert_equal 'bundle exec rspec',        Rspec.new(all: true, file_system: FakeFS.new([])).to_s
        assert_equal 'bin/rspec <test>',         Rspec.new(all: false, file_system: FakeFS.new(['bin/rspec'])).to_s
        assert_equal 'bundle exec rspec <test>', Rspec.new(all: false, file_system: FakeFS.new([])).to_s
        # take into account gem repository which doesn't have a bin/rspec file
        assert_equal 'bundle exec rspec <test>', Rspec.new(all: false).to_s
        assert_equal 'bundle exec rspec',        Rspec.new(all: true).to_s
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
