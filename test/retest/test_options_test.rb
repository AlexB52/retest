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

      assert_equal [expected], TestOptions.for(expected, files: [])
    end
  end
end