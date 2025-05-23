
require 'test_helper'
require_relative 'repository/multiple_test_files_with_user_input.rb'

module Retest
  class RepositoryTest < Minitest::Test
    def setup
      @subject = Repository.new
    end

    def test_add_file
      @subject.files = ['c.txt']
      assert_equal ['c.txt'], @subject.files

      @subject.add('a.txt')

      assert_equal ['a.txt', 'c.txt'], @subject.files
    end

    def test_sync
      @subject.files = []
      assert_equal [], @subject.files

      @subject.sync(added: 'b.txt', removed: 'c.txt')

      assert_equal ['b.txt'], @subject.files

      @subject.sync(added: 'a.txt', removed: 'b.txt')

      assert_equal ['a.txt'], @subject.files
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

      @subject.prompt = Prompt.new(input: StringIO.new("1\n"))

      out, _ = capture_subprocess_io { @subject.find_test('app/models/valuation/holdings.rb') }

      assert_match <<~EXPECTED.chomp, out
        We found few tests matching: app/models/valuation/holdings.rb

        [0] - none
        [1] - test/models/taxation/holdings_test.rb
        [2] - test/models/schedule/holdings_test.rb
        [3] - test/models/holdings_test.rb
        [4] - test/models/performance/holdings_test.rb
        [5] - test/lib/csv_report/holdings_test.rb

        Which file do you want to use?
        Enter the file number now:
        >\s
      EXPECTED
    end

    def test_no_matches_with_multiple_possible_tests
      mock_cache = {}

      @subject.files = %w(
        test/models/schedule/holdings_test.rb
        test/models/taxation/holdings_test.rb
        test/models/holdings_test.rb
        test/models/performance/holdings_test.rb
        test/lib/csv_report/holdings_test.rb
      )

      @subject.cache = mock_cache
      @subject.prompt = Prompt.new(input: StringIO.new("0\n"), output: StringIO.new)

      @subject.find_test('app/models/valuation/holdings.rb')

      assert_equal({ 'app/models/valuation/holdings.rb' => nil }, mock_cache)
    end

    def test_no_matches_with_no_match
      mock_cache = {}

      @subject.files = %w(
        bar.rb
        bar_test.rb
      )

      @subject.cache = mock_cache

      @subject.find_test('foo.rb')

      assert_equal({}, mock_cache)
    end

    class TestFileChanged < Minitest::Test
      def setup
        @subject = Repository.new
      end

      def test_find_test_return_changed_file
        file_changed = expected = 'test/models/schedule/holdings_test.rb'

        assert_equal expected, @subject.find_test(file_changed)
      end
    end

    class TestTestFiles < Minitest::Test
      def setup
        @subject = Repository.new
      end

      def test_returns_test_files_only
        @subject.files = %w(
          exe/retest
          lib/retest.rb
          lib/bottles.rb
          lib/glasses.rb
          lib/pints.rb
          test/bottles_test.rb
          test/glasses_test.rb
          test/plates_test.rb
          test/test_bottles_test.rb
          test/test_glasses_test.rb
          test/test_plates_test.rb
          spec/bottles_spec.rb
          spec/glasses_spec.rb
          spec/plates_spec.rb
          bottles_spec.rb
          glasses_spec.rb
          plates_spec.rb
          bottles_test.rb
          glasses_test.rb
          plates_test.rb
          program.rb
          README.md
          Gemfile
          Gemfile.lock
        )

        assert_equal %w[
          test/bottles_test.rb
          test/glasses_test.rb
          test/plates_test.rb
          test/test_bottles_test.rb
          test/test_glasses_test.rb
          test/test_plates_test.rb
          spec/bottles_spec.rb
          spec/glasses_spec.rb
          spec/plates_spec.rb
          bottles_spec.rb
          glasses_spec.rb
          plates_spec.rb
          bottles_test.rb
          glasses_test.rb
          plates_test.rb
        ], @subject.test_files
      end
    end
  end
end
