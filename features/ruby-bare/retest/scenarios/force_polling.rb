class ForcePollingTest < Minitest::Test
  def setup
    @command = 'retest --ruby --polling'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_match <<~EXPECTED, @output.read
      Launching Retest with polling method...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modifying_existing_file
    launch_retest @command

    modify_file('program.rb')

    assert_match "Test file: program_test.rb", @output.read
    assert_match "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end

  def test_modifying_existing_test_file
    launch_retest @command

    modify_file('program_test.rb')

    assert_match "Test file: program_test.rb", @output.read
    assert_match "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end

  def test_creating_a_new_test_file
    launch_retest @command

    create_file 'foo_test.rb'

    assert_match "Test file: foo_test.rb", @output.read

  ensure
    delete_file 'foo_test.rb'
  end

  def test_creating_a_new_file
    launch_retest @command

    create_file 'foo.rb'
    assert_match <<~EXPECTED, @output.read
      FileNotFound - Retest could not find a matching test file to run.
    EXPECTED

    create_file 'foo_test.rb'
    assert_match "Test file: foo_test.rb", @output.read

    modify_file('program.rb')
    assert_match "Test file: program_test.rb", @output.read

    modify_file('foo.rb')
    assert_match "Test file: foo_test.rb", @output.read

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end

  def test_untracked_file
    create_file 'foo.rb', should_sleep: false
    create_file 'foo_test.rb', should_sleep: false

    launch_retest @command

    modify_file 'foo.rb'
    assert_match "Test file: foo_test.rb", @output.read

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end
end
