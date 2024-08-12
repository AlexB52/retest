class FileChangesTest < Minitest::Test
  def setup
    @command = 'retest --rspec'
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

  def test_modifying_existing_file
    launch_retest @command

    modify_file('lib/bottles.rb')

    assert_match "Test File Selected: spec/bottles_spec.rb", @output.read
    assert_match "12 examples, 0 failures", @output.read
  end

  def test_modifying_existing_test_file
    launch_retest @command

    modify_file('spec/bottles_spec.rb')

    assert_match "Test File Selected: spec/bottles_spec.rb", @output.read
    assert_match "12 examples, 0 failures", @output.read
  end

  def test_creating_a_new_test_file
    launch_retest @command

    create_file 'foo_spec.rb'

    assert_match "Test File Selected: foo_spec.rb", @output.read

  ensure
    delete_file 'foo_spec.rb'
  end

  def test_creating_a_new_file
    launch_retest @command

    create_file 'foo.rb'
    assert_match <<~EXPECTED, @output.read
      404 - Test File Not Found
      Retest could not find a matching test file to run.
    EXPECTED

    create_file 'foo_spec.rb'
    assert_match "Test File Selected: foo_spec.rb", @output.read

    modify_file('lib/bottles.rb')
    assert_match "Test File Selected: spec/bottles_spec.rb", @output.read

    modify_file('foo.rb')
    assert_match "Test File Selected: foo_spec.rb", @output.read

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_spec.rb'
  end

  def test_untracked_file
    create_file 'foo.rb', should_sleep: false
    create_file 'foo_spec.rb', should_sleep: false

    launch_retest @command

    modify_file 'foo.rb'
    assert_match "Test File Selected: foo_spec.rb", @output.read

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_spec.rb'
  end
end
