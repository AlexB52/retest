require 'test_helper'

module Retest
  class TestRootLevelFiles < MiniTest::Test
    def test_root_file_level
      files = %w(foo_spec.rb)

      assert_equal files, MatchingOptions.for('foo_spec.rb', files: files)

      files = %w(foo.rb)

      assert_equal [], MatchingOptions.for('foo.rb', files: files)

      files = %w(foo.rb foo_spec.rb)

      assert_equal %w[foo_spec.rb], MatchingOptions.for('foo.rb', files: files)
    end
  end

  class TestPrefixPatternTest < MiniTest::Test
    def test_find_test
      files = %w(
        test/songs/99bottles.txt
        test/test_bottles.rb
        README.md
        lib/bottles.rb
        Gemfile
        Gemfile.lock
      )

      assert_equal ['test/test_bottles.rb'],
        MatchingOptions.for('99bottles_ruby/lib/bottles.rb', files: files)
    end


    def test_return_test_file_when_changed
      file_changed = expected = 'test/models/schedule/test_holdings.rb'

      assert_equal [expected], MatchingOptions.for(file_changed, files: [])
    end

    def test_multiple_matches
      files = %w(
        test/models/schedule/test_holdings.rb
        test/models/schedule/test_holdings.rb
        test/models/taxation/test_holdings.rb
        test/models/test_holdings.rb
        test/models/performance/test_holdings.rb
        test/models/valuation/test_holdings.rb
        test/lib/csv_report/test_holdings.rb
      )

      assert_equal ['test/models/valuation/test_holdings.rb'], MatchingOptions.for('app/models/valuation/holdings.rb', files: files)
    end

    def test_no_namespace_matching
      files = %w(
        test/models/taxation/test_holdings.rb
        test/models/test_holdings.rb
        test/models/schedule/test_holdings.rb
        test/models/performance/test_holdings.rb
        test/lib/csv_report/test_holdings.rb
      )

      assert_equal files, MatchingOptions.for('app/models/valuation/holdings.rb', files: files)
    end
  end

  class TestSuffixPatternTest < MiniTest::Test
    def test_find_test
      files = %w(
        test/songs/99bottles.txt
        test/bottles_test.rb
        README.md
        lib/bottles.rb
        Gemfile
        Gemfile.lock
      )

      assert_equal ['test/bottles_test.rb'],
        MatchingOptions.for('99bottles_ruby/lib/bottles.rb', files: files)
    end

    def test_return_test_file_when_changed
      file_changed = expected = 'test/models/schedule/holdings_test.rb'

      assert_equal [expected], MatchingOptions.for(file_changed, files: [])
    end

    def test_multiple_matches_on_hanami_setup
      files = File.read('test/fixtures/setups/hanami.txt').split("\n")

      assert_equal [], MatchingOptions.for('apps/web/templates/books/index.html.erb', files: files)
      assert_equal ['spec/web/controllers/books/index_spec.rb'], MatchingOptions.for('apps/web/controllers/books/index.rb', files: files)
      assert_equal ['spec/web/views/books/index_spec.rb'], MatchingOptions.for('apps/web/views/books/index.rb', files: files)
    end

    def test_multiple_matches
      files = %w(
        test/models/schedule/holdings_test.rb
        test/models/taxation/holdings_test.rb
        test/models/holdings_test.rb
        test/models/performance/holdings_test.rb
        test/models/valuation/holdings_test.rb
        test/lib/csv_report/holdings_test.rb
      )

      assert_equal ['test/models/valuation/holdings_test.rb'], MatchingOptions.for('app/models/valuation/holdings.rb', files: files)
    end

    def test_no_namespace_matching
      files = %w(
        test/models/taxation/holdings_test.rb
        test/models/schedule/holdings_test.rb
        test/models/holdings_test.rb
        test/models/performance/holdings_test.rb
        test/lib/csv_report/holdings_test.rb
      )

      assert_equal files, MatchingOptions.for('app/models/valuation/holdings.rb', files: files)
    end
  end

  class MultiplePatternTest < MiniTest::Test
    def test_no_default_pattern_match
      files = %w(
        lib/active_record/fixtures.rb
        lib/active_record/test_fixtures.rb
        test/cases/test_fixtures_test.rb
        test/cases/fixtures_test.rb
      )

      expected = %w[
        lib/active_record/test_fixtures.rb
        test/cases/fixtures_test.rb
        test/cases/test_fixtures_test.rb
      ]

      assert_equal expected, MatchingOptions.for('lib/active_record/fixtures.rb', files: files)
    end

    def test_multiple_pattern_combinations
      files = %w(
        lib/active_record/fixtures.rb
        lib/active_record/test_fixtures.rb
        test/cases/test_fixtures_test.rb
        test/cases/fixtures_test.rb
      )

      assert_equal %w[test/cases/test_fixtures_test.rb], MatchingOptions.for('lib/active_record/test_fixtures.rb', files: files)
    end

    def test_multiple_test_naming_patterns
      files = %w(
        spec_holdings.rb
        test_holdings.rb
        holdings_spec.rb
        holdings_test.rb
        spec/holdings_spec.rb
        spec/holdings_test.rb
        test/holdings_spec.rb
        test/holdings_test.rb
      )

      assert_equal files, MatchingOptions.for('lib/holdings.rb', files: files, limit: 8)
    end
  end
end
