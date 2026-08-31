require 'test_helper'
require_relative 'shared_interface'
require 'fileutils'
require 'tmpdir'

module Retest
  class VersionControl::GitTest < Minitest::Test
    include VersionControl::SharedInterface

    def setup
      @subject = VersionControl::Git
    end

    def test_diff_names
      assert_respond_to @subject, :diff_files
    end

    def test_diff_files_include_committed_staged_and_unstaged_changes_once
      in_git_repository do
        write_file('committed.rb', 'puts "base"')
        write_file('duplicate.rb', 'puts "base"')
        write_file('staged.rb', 'puts "base"')
        write_file('unstaged.rb', 'puts "base"')
        git('add', '.')
        git('commit', '-m', 'Initial commit')

        write_file('committed.rb', 'puts "committed"')
        write_file('duplicate.rb', 'puts "committed"')
        git('add', 'committed.rb', 'duplicate.rb')
        git('commit', '-m', 'Committed changes')

        write_file('duplicate.rb', 'puts "staged"')
        write_file('staged.rb', 'puts "staged"')
        git('add', 'duplicate.rb', 'staged.rb')

        write_file('duplicate.rb', 'puts "unstaged"')
        write_file('unstaged.rb', 'puts "unstaged"')

        assert_equal %w[
          committed.rb
          duplicate.rb
          staged.rb
          unstaged.rb
        ], @subject.diff_files('HEAD~1')
      end
    end

    private

    def in_git_repository
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          git('init', '-q')
          git('config', 'user.email', 'retest@example.com')
          git('config', 'user.name', 'Retest')

          yield
        end
      end
    end

    def write_file(path, content)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, content)
    end

    def git(*args)
      assert system('git', *args, out: File::NULL), args.join(' ')
    end
  end
end
