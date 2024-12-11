require 'retest'
require_relative 'support/test_helper'
require 'minitest/autorun'

$stdout.sync = true

class FileChangesTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest --ruby'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_output_matches <<~EXPECTED
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end

class GitChangesTest < Minitest::Test
  include RetestHelper

  def setup
    `git config --global init.defaultBranch main`
    `git config --global --add safe.directory /usr/src/app`
    `git config --global user.email "you@example.com"`
    `git config --global user.name "Your Name"`
    `git init`
    `git add .`
    `git commit -m "First commit"`
    `git checkout -b feature-branch`
  end

  def teardown
    `git checkout -`
    `git clean -fd`
    `git branch -D feature-branch`
    `rm -rf .git`
  end

  def test_diffs_from_other_branch
    delete_file('lib/to_be_deleted.rb', sleep_for: 0)
    rename_file('lib/to_be_renamed.rb', 'lib/renamed.rb', sleep_for: 0)
    rename_file('lib/to_be_renamed_with_test_file.rb', 'lib/renamed_with_test_file.rb', sleep_for: 0)
    rename_file('test/to_be_renamed_with_test_file_test.rb', 'test/renamed_with_test_file_test.rb', sleep_for: 0)
    create_file('lib/created.rb', sleep_for: 0)
    create_file('lib/created_with_test_file.rb', sleep_for: 0)
    create_file('test/created_with_test_file_test.rb', sleep_for: 0)

    `git add .`
    `git commit -m "Rename, Add and Remove files"`

    launch_retest 'retest --diff=main --ruby'

    assert_output_matches <<~EXPECTED
      Tests selected:
        - test/created_with_test_file_test.rb
        - test/renamed_with_test_file_test.rb
        - test/to_be_renamed_test.rb
    EXPECTED
  end
end