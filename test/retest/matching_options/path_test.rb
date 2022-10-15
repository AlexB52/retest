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
    end
  end
end
