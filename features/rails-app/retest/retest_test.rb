require 'retest'
require_relative 'support/test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class MatchingTestsCommandTest < Minitest::Test
  def setup
    @command = 'retest --rails'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modify_a_file
    launch_retest @command

    modify_file 'app/models/post.rb'

    assert_match "Test File Selected: test/models/post_test.rb", @output.read
    assert_match "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end
end

class AllTestsCommandTest < Minitest::Test
  def setup
    @command = 'retest --rails --all'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modify_a_file
    launch_retest @command

    modify_file 'app/models/post.rb'

    assert_match "8 runs, 10 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end
end

class AutoFlagTest < Minitest::Test
  def teardown
    end_retest
  end

  def test_with_no_command
    launch_retest 'retest'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RAILS]. Using command: 'bin/rails test <test>'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end

  def test_with_no_command_all
    launch_retest 'retest --all'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RAILS]. Using command: 'bin/rails test'
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
    @output.delete
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
    wait

    assert_match <<~EXPECTED, @output.read
      Setup identified: [RAILS]. Using command: 'bin/rails test <test>'
      Tests found:
        - test/controllers/books_controller_test.rb
        - test/models/book_test.rb
        - test/system/books_test.rb
      Running tests...
      Test Files Selected: test/controllers/books_controller_test.rb test/models/book_test.rb test/system/books_test.rb
    EXPECTED

    assert_match <<~EXPECTED, @output.read
      7 runs, 9 assertions, 0 failures, 0 errors, 0 skips
    EXPECTED
  end
end