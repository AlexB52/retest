require 'test_helper'
require_relative 'repository/multiple_test_files_with_user_input.rb'

module Retest
  class RepositoryTest < MiniTest::Test
    def setup
      @subject = Repository.new
    end

    def test_add_file
      @subject.files = ['c.txt']
      assert_equal ['c.txt'], @subject.files

      @subject.add('a.txt')

      assert_equal ['a.txt', 'c.txt'], @subject.files
    end

    def test_add_multiple_files
      @subject.files = []
      assert_equal [], @subject.files

      @subject.add(['c.txt', 'a.txt', 'b.txt'])

      assert_equal ['a.txt', 'b.txt', 'c.txt'], @subject.files
    end

    def test_remove_file
      @subject.files = ['c.txt']
      assert_equal ['c.txt'], @subject.files

      @subject.remove('c.txt')

      assert_equal [], @subject.files

      @subject.remove('c.txt')
      assert_equal [], @subject.files

      @subject.remove []
      assert_equal [], @subject.files

      @subject.remove nil
      assert_equal [], @subject.files
    end

    def test_remove_multiple_files
      @subject.files = ['c.txt', 'a.txt', 'b.txt']

      @subject.remove(['a.txt', 'b.txt'])

      assert_equal ['c.txt'], @subject.files
    end

    def test_find_tests
      @subject.files = %w(
        exe/retest
        lib/retest.rb
        lib/bottles.rb
        lib/glasses.rb
        lib/pints.rb
        test/bottles_test.rb
        test/glasses_test.rb
        test/plates_test.rb
        program.rb
        README.md
        Gemfile
        Gemfile.lock
      )

      assert_equal [
        'test/bottles_test.rb',
        'test/glasses_test.rb',
      ], @subject.find_tests(['exe/retest', 'lib/glasses.rb', '99bottles_ruby/lib/bottles.rb',])
    end

    def test_find_test
      @subject.files = %w(
        test/songs/99bottles.txt
        test/bottles_test.rb
        program.rb
        README.md
        lib/bottles.rb
        Gemfile
        Gemfile.lock
      )

      assert_equal 'test/bottles_test.rb', @subject.find_test('99bottles_ruby/lib/bottles.rb')
    end

    def test_find_test_edge_cases
      @subject.files = []

      assert_nil @subject.find_test nil

      @subject.files = []

      assert_nil @subject.find_test ''
    end

    def test_cache
      mock_cache = {}

      Repository.new(files: ['file_path_test.rb'], cache: mock_cache).find_test('file_path.rb')

      assert_equal({ "file_path.rb" => "file_path_test.rb" }, mock_cache)
    end

    def test_find_test_similar_files_but_no_exact_match
      @subject.files = %w(
        test/models/schedule/holdings_test.rb
        test/models/taxation/holdings_test.rb
        test/models/holdings_test.rb
        test/models/performance/holdings_test.rb
        test/lib/csv_report/holdings_test.rb
      )
      @subject.input_stream = StringIO.new("1\n")

      out, _ = capture_subprocess_io { @subject.find_test('app/models/valuation/holdings.rb') }

      assert_match <<~EXPECTED, out
        We found few tests matching: app/models/valuation/holdings.rb
        [0] - test/models/taxation/holdings_test.rb
        [1] - test/models/schedule/holdings_test.rb
        [2] - test/models/performance/holdings_test.rb
        [3] - test/models/holdings_test.rb
        [4] - test/lib/csv_report/holdings_test.rb

        Which file do you want to use?
        Enter the file number now:
      EXPECTED
    end

    class TestFileChanged < MiniTest::Test
      def setup
        @subject = Repository.new
      end

      def test_find_test_return_changed_file
        file_changed = expected = 'test/models/schedule/holdings_test.rb'

        assert_equal expected, @subject.find_test(file_changed)
      end
    end
  end
end