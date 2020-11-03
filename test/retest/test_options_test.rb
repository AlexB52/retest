require 'test_helper'

module Retest
  class TestOptionsTest < MiniTest::Test
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
        TestOptions.for('99bottles_ruby/lib/bottles.rb', files: files)
    end

    def test_return_test_file_when_changed
      file_changed = expected = 'test/models/schedule/holdings_test.rb'

      assert_equal [expected], TestOptions.for(file_changed, files: [])
    end

    def test_multiple_matches_on_hanami_setup
      files = File.read('test/fixtures/setups/hanami.txt').split("\n")

      assert_equal [], TestOptions.for('apps/web/templates/books/index.html.erb', files: files)
      assert_equal ['spec/web/controllers/books/index_spec.rb'], TestOptions.for('apps/web/controllers/books/index.rb', files: files)
      assert_equal ['spec/web/views/books/index_spec.rb'], TestOptions.for('apps/web/views/books/index.rb', files: files)
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

      assert_equal ['test/models/valuation/holdings_test.rb'], TestOptions.for('app/models/valuation/holdings.rb', files: files)
    end

    def test_no_namespace_matching
      files = %w(
        test/models/taxation/holdings_test.rb
        test/models/schedule/holdings_test.rb
        test/models/performance/holdings_test.rb
        test/models/holdings_test.rb
        test/lib/csv_report/holdings_test.rb
      )

      assert_equal files, TestOptions.for('app/models/valuation/holdings.rb', files: files)
    end
  end
end
