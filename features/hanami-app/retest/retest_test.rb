require 'retest'
require_relative 'support/test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class MatchingTestsCommandTest < Minitest::Test
  def setup
    @command = "retest --rake"
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

    modify_file 'apps/web/controllers/books/create.rb'

    assert_match "Test File Selected: spec/web/controllers/books/create_spec.rb", @output.read
    assert_match "4 runs, 7 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end
end

class AllTestsCommandTest < Minitest::Test
  def setup
    @command = 'retest --rake --all'
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

    modify_file 'apps/web/controllers/books/create.rb'

    assert_match "15 runs, 27 assertions, 0 failures, 0 errors, 1 skips", @output.read
  end
end

class AutoFlagTest < Minitest::Test
  def teardown
    end_retest
  end

  def test_with_no_command
    launch_retest 'retest'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RAKE]. Using command: 'bundle exec rake test TEST=<test>'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end

  def test_with_no_command_all
    launch_retest 'retest --all'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RAKE]. Using command: 'bundle exec rake test'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end
end

class SetupTest < Minitest::Test
  def test_repository_setup
    assert_equal :rake, Retest::Setup.new.type
  end
end