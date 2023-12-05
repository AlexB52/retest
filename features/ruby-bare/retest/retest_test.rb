require_relative 'test_helper'
require 'minitest/autorun'

require_relative 'scenarios/auto_flag.rb'
require_relative 'scenarios/custom_extensions.rb'
require_relative 'scenarios/changed_placeholder.rb'
require_relative 'scenarios/changed_and_test_placeholders.rb'
require_relative 'scenarios/multiple_commands.rb'
require_relative 'scenarios/force_polling.rb'
require_relative 'scenarios/interruptions.rb'

require_relative 'flags/help.rb'
require_relative 'flags/version.rb'

$stdout.sync = true

include FileHelper

class SetupTest < Minitest::Test
  def test_repository_setup
    assert_equal :ruby, Retest::Setup.new.type
  end
end

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

  def test_modifying_existing_file
    @output, @pid = launch_retest @command

    modify_file('program.rb')

    assert_match "Test File Selected: program_test.rb", @output.read
    assert_match "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end

  def test_modifying_existing_test_file
    @output, @pid = launch_retest @command

    modify_file('program_test.rb')

    assert_match "Test File Selected: program_test.rb", @output.read
    assert_match "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips", @output.read
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

    modify_file('program.rb')
    assert_match "Test File Selected: program_test.rb", @output.read

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
