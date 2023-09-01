require 'test_helper'

module Retest
  class MatchingOptions
    class PathTest < MiniTest::Test
      def setup
        @subject = Path.new('test/models/taxation/test_holdings.rb')
      end

      def test_reversed_dirnames
        assert_equal %w(taxation models test), @subject.reversed_dirnames
      end

      def test_dirnames
        assert_equal %w(test models taxation), @subject.dirnames
      end

      def test_to_s
        assert_equal "test/models/taxation/test_holdings.rb", @subject.to_s
      end

      def test_basename
        assert_equal Pathname("test_holdings.rb"), @subject.basename
      end

      def test_extname
        assert_equal ".rb", @subject.extname
      end

      def test_dirname
        assert_equal Pathname("test/models/taxation"), @subject.dirname
      end

      def test_test?
        refute Path.new("lib/active_record/fixtures.rb").test?
        assert Path.new("lib/active_record/test_fixtures.rb").test?
        assert Path.new("test/cases/test_fixtures_test.rb").test?
        assert Path.new("test/cases/fixtures_test.rb").test?

        refute Path.new("lib/active_record/fixtures.rb").test?(test_directories: %w[test])
        refute Path.new("lib/active_record/test_fixtures.rb").test?(test_directories: %w[test])
        assert Path.new("test/cases/test_fixtures_test.rb").test?(test_directories: %w[test])
        assert Path.new("test/cases/fixtures_test.rb").test?(test_directories: %w[test])

        # assert root level files regardless of test_directories
        assert Path.new("foo_spec.rb").test?
        refute Path.new("foo_spec.rb").test?(test_directories: %w[spec test])
        assert Path.new("foo_spec.rb").test?(test_directories: %w[spec test .])
        refute Path.new("foo.rb").test?(test_directories: %w[spec test])
        refute Path.new("foo.rb").test?
      end

      def test_possible_test?
        path = Path.new('lib/active_record/fixtures.rb')

        assert path.possible_test?('lib/active_record/test_fixtures.rb')
        assert path.possible_test?('test/cases/test_fixtures_test.rb')
        assert path.possible_test?('test/cases/fixtures_test.rb')
      end
    end
  end
end
