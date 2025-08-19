
require 'test_helper'
require_relative 'repository/multiple_test_files_with_user_input.rb'

module Retest
  class TestRepoFiles < Minitest::Test
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
  end

  class TestRepoFindTest < Minitest::Test
    def setup
      @subject = Repository.new
    end

    def test_happy_path
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

    def test_edge_cases
      @subject.files = []

      assert_nil @subject.find_test nil

      @subject.files = []

      assert_nil @subject.find_test ''
    end

    def test_similar_files_but_no_exact_match
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

    def test_called_with_test_file
      @subject.files = %w(
        test/songs/99bottles.txt
        test/bottles_test.rb
        program.rb
        README.md
        lib/bottles.rb
        Gemfile
        Gemfile.lock
      )

      assert_equal 'test/bottles_test.rb', @subject.find_test('test/bottles_test.rb')
    end

    def test_called_with_test_file_but_no_match
      @subject.files = []

      assert_nil @subject.find_test('test/bottles_test.rb')
    end

    def test_with_incomplete_path
      @subject.files = %w(
        test/songs/99bottles.txt
        test/bottles_test.rb
        program.rb
        README.md
        lib/bottles.rb
        Gemfile
        Gemfile.lock
      )

      file_changed = expected = 'test/models/schedule/holdings_test.rb'

      @subject.files = [expected]

      assert_equal expected, @subject.find_test(file_changed)
    end
  end

  class TestRepoFindTests < Minitest::Test
    def setup
      @subject = Repository.new(files: %w(
        exe/retest
        lib/retest.rb
        lib/bottles.rb
        lib/glasses.rb
        lib/pints.rb
        test/bottles/cap_test.rb
        test/bottles/limit_test.rb
        test/bottles_test.rb
        test/glasses_test.rb
        test/plates_test.rb
        test/program_test.rb
        program.rb
        program_test.rb
        README.md
        Gemfile
        Gemfile.lock
      ))
    end

    def test_find_tests
      assert_equal [
        'test/bottles_test.rb',
        'test/glasses_test.rb',
      ], @subject.find_tests(%w[exe/retest lib/glasses.rb 99bottles_ruby/lib/bottles.rb])
    end

    def test_find_multiple_exact_tests
      assert_equal [
        'test/bottles_test.rb',
        'test/glasses_test.rb',
      ], @subject.find_tests(%w[exe/retest lib/glasses.rb lib/glasses.rb 99bottles_ruby/lib/bottles.rb ])
    end

    def test_find_test_files
      assert_equal [
        'test/bottles_test.rb',
        'test/glasses_test.rb',
      ], @subject.find_tests(%w[test/bottles_test.rb test/glasses_test.rb])
    end

    def test_find_multipe_same_test_files
      assert_equal [
        'test/bottles_test.rb',
        'test/glasses_test.rb',
      ], @subject.find_tests(%w[test/bottles_test.rb test/glasses_test.rb test/glasses_test.rb])
    end

    def test_find_multiple_same_files_with_incomplete_paths
      assert_equal [
        'test/bottles_test.rb',
      ], @subject.find_tests(%w[bottles_test.rb])
    end
  end

  class TestRepoSearchTests < Minitest::Test
    def setup
      @subject = Repository.new(files: %w(
        exe/retest
        lib/retest.rb
        lib/bottles.rb
        lib/glasses.rb
        lib/pints.rb
        test/bottles/cap_test.rb
        test/bottles/limit_test.rb
        test/bottles_test.rb
        test/glasses_test.rb
        test/plates_test.rb
        test/program_test.rb
        program.rb
        program_test.rb
        README.md
        Gemfile
        Gemfile.lock
      ))
    end

    def test_search_results
      assert_equal({
        "test/bottles_test.rb" => "test/bottles_test.rb",
        "lib/bottles.rb"       => "test/bottles_test.rb",
        "test/plates_test.rb"  => "test/plates_test.rb",
        "test/unknown_test.rb" => nil,
        "lib/unknown.rb"       => nil,
        "lib/glasses.rb"       => "test/glasses_test.rb",
      }, @subject.search_tests(%w[
        test/bottles_test.rb
        lib/bottles.rb
        test/bottles_test.rb
        test/plates_test.rb
        test/unknown_test.rb
        lib/unknown.rb
        lib/glasses.rb
      ]))
    end
  end

  class TestRepoCache < Minitest::Test
    def setup
      @cache = {}
      @subject = Repository.new(cache: @cache)
    end

    def test_cache
      @subject.files = ['file_path_test.rb']
      @subject.find_test('file_path.rb')

      assert_equal({ "file_path.rb" => "file_path_test.rb" }, @cache)
    end

    def test_no_matches_with_multiple_possible_tests
      @subject.files = %w(
        test/models/schedule/holdings_test.rb
        test/models/taxation/holdings_test.rb
        test/models/holdings_test.rb
        test/models/performance/holdings_test.rb
        test/lib/csv_report/holdings_test.rb
      )

      @subject.prompt = Prompt.new(input: StringIO.new("0\n"), output: StringIO.new)

      @subject.find_test('app/models/valuation/holdings.rb')

      assert_equal({ 'app/models/valuation/holdings.rb' => nil }, @cache)
    end

    def test_no_matches_with_no_match
      @subject.files = %w(
        bar.rb
        bar_test.rb
      )

      @subject.find_test('foo.rb')

      assert_equal({}, @cache)
    end
  end

  class TestRepoTestFiles < Minitest::Test
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
