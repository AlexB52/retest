require 'test_helper'
require_relative 'repository/multiple_test_files_with_user_input.rb'

module Retest
  class RepositoryTest < MiniTest::Test
    def setup
      @subject = Repository.new
    end

    def test_default_files
      assert_equal Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*'), @subject.files
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

      assert_equal 'test/bottles_test.rb',
        @subject.find_test('99bottles_ruby/lib/bottles.rb')
    end

    def test_cache
      mock_cache = {}
      expected = { "file_path.rb" => "file_path_test.rb" }

      Repository.new(files: ['file_path_test.rb'], cache: mock_cache)
        .find_test('file_path.rb')

      assert_equal expected, mock_cache
    end
  end
end