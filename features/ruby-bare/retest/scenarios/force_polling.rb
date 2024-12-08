class ForcePollingTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest --ruby --polling'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_output_matches <<~EXPECTED
      Launching Retest with polling method...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modifying_existing_file
    launch_retest @command

    modify_file('program.rb')

    assert_output_matches(
      "Test file: program_test.rb",
      "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips")
  end

  def test_modifying_existing_test_file
    launch_retest @command

    modify_file('program_test.rb')

    assert_output_matches(
      "Test file: program_test.rb",
      "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips")
  end

  def test_creating_a_new_test_file
    launch_retest @command

    create_file 'foo_test.rb'

    assert_output_matches "Test file: foo_test.rb"

  ensure
    delete_file 'foo_test.rb'
  end

  def test_creating_a_new_file
    launch_retest @command

    create_file 'foo.rb'
    assert_output_matches "FileNotFound - Retest could not find a matching test file to run."

    create_file 'foo_test.rb'
    assert_output_matches "Test file: foo_test.rb"

    modify_file('program.rb')
    assert_output_matches "Test file: program_test.rb"

    modify_file('foo.rb')
    assert_output_matches "Test file: foo_test.rb"

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end

  def test_untracked_file
    create_file 'foo.rb', sleep_for: 0
    create_file 'foo_test.rb', sleep_for: 0

    launch_retest @command

    modify_file 'foo.rb'
    assert_output_matches "Test file: foo_test.rb"

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end
end
