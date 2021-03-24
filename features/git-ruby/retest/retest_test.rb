require_relative 'test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class FileChangesTest < Minitest::Test
  def setup
    @command = 'retest --ruby'
  end

  def teardown
    end_retest @output, @pid
  end

  def test_start_retest
    @output, @pid = launch_retest @command

    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end

class GitChangesTest < Minitest::Test
  def setup
  end

  def teardown
  end

  def test_diffs_from_other_branch
    `git init`
    `git config --global user.email "you@example.com"`
    `git config --global user.name "Your Name"`
    `git add .`
    `git commit -m "First commit"`
    `git checkout -b feature-branch`

    delete_file('lib/to_be_deleted.rb')
    rename_file('lib/to_be_renamed.rb', 'lib/renamed.rb')
    rename_file('lib/to_be_renamed_with_test_file.rb', 'lib/renamed_with_test_file.rb')
    rename_file('test/to_be_renamed_with_test_file_test.rb', 'test/renamed_with_test_file_test.rb')
    create_file('lib/created.rb', should_sleep: false)
    create_file('lib/created_with_test_file.rb', should_sleep: false)
    create_file('lib/created_with_test_file_test.rb', should_sleep: false)

    `git add .`
    `git commit -m "Rename, Add and Remove files"`

    out, _ = capture_subprocess_io { `retest --diff=master --ruby` }

    
  end
end