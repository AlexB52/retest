require_relative 'test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class MatchingTestsCommandTest < Minitest::Test
  def setup
    @command = 'retest --rails'
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

  def test_modify_a_file
    @output, @pid = launch_retest @command

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
    end_retest @output, @pid
  end

  def test_start_retest
    @output, @pid = launch_retest @command

    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modify_a_file
    @output, @pid = launch_retest @command

    modify_file 'app/models/post.rb'

    assert_match "8 runs, 10 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end
end

class SetupTest < Minitest::Test
  def test_repository_setup
    assert_equal :rails, Retest::Setup.new.type
  end
end