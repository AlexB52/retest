class FileChangesTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest --rspec'
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

  def test_modifying_existing_file
    launch_retest @command

    modify_file('lib/bottles.rb')

    assert_output_matches(
      "Test file: spec/bottles_spec.rb",
      "12 examples, 0 failures")
  end

  def test_modifying_existing_test_file
    launch_retest @command

    modify_file('spec/bottles_spec.rb')

    assert_output_matches(
      "Test file: spec/bottles_spec.rb",
      "12 examples, 0 failures")
  end

  def test_creating_a_new_test_file
    launch_retest @command

    create_file 'foo_spec.rb'

    assert_output_matches "Test file: foo_spec.rb"

  ensure
    delete_file 'foo_spec.rb'
  end

  def test_creating_a_new_file
    launch_retest @command

    create_file 'foo.rb'
    assert_output_matches <<~EXPECTED
      FileNotFound - Retest could not find a matching test file to run.
    EXPECTED

    create_file 'foo_spec.rb'
    assert_output_matches "Test file: foo_spec.rb"

    modify_file('lib/bottles.rb')
    assert_output_matches "Test file: spec/bottles_spec.rb"

    modify_file('foo.rb')
    assert_output_matches "Test file: foo_spec.rb"

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_spec.rb'
  end

  def test_untracked_file
    create_file 'foo.rb', sleep_for: 0
    create_file 'foo_spec.rb', sleep_for: 0

    launch_retest @command

    modify_file 'foo.rb'
    assert_output_matches "Test file: foo_spec.rb"

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_spec.rb'
  end
end
