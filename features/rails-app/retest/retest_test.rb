require 'retest'
require_relative 'support/test_helper'
require 'minitest/autorun'

$stdout.sync = true

class MatchingTestsCommandTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest --rails'
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

    write_input("\n") # Trigger last command when no command was run

    assert_output_matches <<~EXPECTED
      Error - Not enough information to run a command. Please trigger a run first.
    EXPECTED
  end

  def test_modify_a_file
    launch_retest @command

    modify_file 'app/models/post.rb'

    assert_output_matches(
      "Test file: test/models/post_test.rb",
      "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips")
  end
end

class AllTestsCommandTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest --rails --all'
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

    write_input("\n") # Trigger all command when no command was run

    assert_output_matches "8 runs, 10 assertions, 0 failures, 0 errors, 0 skips"
  end

  def test_modify_a_file
    launch_retest @command

    modify_file 'app/models/post.rb'

    assert_output_matches "8 runs, 10 assertions, 0 failures, 0 errors, 0 skips"
  end
end

class AutoFlagTest < Minitest::Test
  include RetestHelper

  def teardown
    end_retest
  end

  def test_with_no_command
    launch_retest 'retest'

    assert_output_matches <<~OUTPUT
      Setup: [RAILS]
      Command: 'bin/rails test <test>'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end

  def test_with_no_command_all
    launch_retest 'retest --all'

    assert_output_matches <<~OUTPUT
      Setup: [RAILS]
      Command: 'bin/rails test'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end
end

class SetupTest < Minitest::Test
  def test_repository_setup
    assert_equal :rails, Retest::Setup.new.type
  end
end

class DiffOptionTest < Minitest::Test
  include RetestHelper

  def setup
    `git config --global init.defaultBranch main`
    `git config --global user.email "you@example.com"`
    `git config --global user.name "Your Name"`
    `git config --global --add safe.directory /usr/src/app`
    `git init`
    `git add .`
    `git commit -m "First commit"`
    `git checkout -b feature-branch`
  end

  def teardown
    `git checkout -`
    `git clean -fd .`
    `git checkout .`
    `git branch -D feature-branch`
    `rm -rf .git`
    `bin/rails db:reset RAILS_ENV=test`
  end

  def test_diffs_from_other_branch
    `bin/rails g scaffold books title:string`
    `bin/rails db:migrate RAILS_ENV=test`
    `git add .`
    `git commit -m "Scaffold books"`

    launch_retest 'retest --diff=main'

    assert_output_matches <<~EXPECTED, "7 runs, 9 assertions, 0 failures, 0 errors, 0 skips"
      Setup: [RAILS]
      Command: 'bin/rails test <test>'
      Tests selected:
        - test/controllers/books_controller_test.rb
        - test/models/book_test.rb
        - test/system/books_test.rb
    EXPECTED
  end
end