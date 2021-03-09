require_relative 'test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class RailsTest < Minitest::Test
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

  def test_modifying_existing_file
    @output, @pid = launch_retest @command

    modify_file('lib/bottles.rb')

    assert_match "Test File Selected: test/bottles_test.rb", @output.read
    assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end

  def test_modifying_existing_test_file
    @output, @pid = launch_retest @command

    modify_file('test/bottles_test.rb')

    assert_match "Test File Selected: test/bottles_test.rb", @output.read
    assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end

  def test_creating_a_new_test_file
    @output, @pid = launch_retest @command

    create_file 'foo_test.rb'

    assert_match "Test File Selected: foo_test.rb", @output.read

    delete_file 'foo_test.rb'
  end

  def test_creating_a_new_file
    @output, @pid = launch_retest @command

    create_file 'foo.rb'
    assert_match <<~EXPECTED, @output.read
      404 - Test File Not Found
      Retest could not find a matching test file to run.
    EXPECTED

    create_file 'foo_test.rb'
    assert_match "Test File Selected: foo_test.rb", @output.read

    modify_file('lib/bottles.rb')
    assert_match "Test File Selected: test/bottles_test.rb", @output.read

    modify_file('foo.rb')
    assert_match "Test File Selected: foo_test.rb", @output.read

    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end

  def test_untracked_file
    create_file 'foo.rb', should_sleep: false
    create_file 'foo_test.rb', should_sleep: false

    @output, @pid = launch_retest @command

    modify_file 'foo.rb'
    assert_match "Test File Selected: foo_test.rb", @output.read

    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end
end
