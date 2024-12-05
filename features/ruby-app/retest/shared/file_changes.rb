module FileChanges
  def teardown
    end_retest
  end

  def test_modifying_existing_file
    launch_retest(@command)

    modify_file('lib/bottles.rb')

    read_output do |output|
      assert_match "Test file: test/bottles_test.rb", output
      assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", output
    end
  end

  def test_modifying_existing_test_file
    launch_retest(@command)

    modify_file('test/bottles_test.rb')

    read_output do |output|
      assert_match "Test file: test/bottles_test.rb", output
      assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", output
    end
  end

  def test_creating_a_new_test_file
    launch_retest(@command)

    create_file 'foo_test.rb'

    assert_match "Test file: foo_test.rb", read_output

  ensure
    delete_file 'foo_test.rb'
  end

  def test_creating_a_new_file
    launch_retest(@command)

    create_file 'foo.rb'
    assert_match <<~EXPECTED, read_output
      FileNotFound - Retest could not find a matching test file to run.
    EXPECTED

    create_file 'foo_test.rb'
    assert_match "Test file: foo_test.rb", read_output

    modify_file('lib/bottles.rb')
    assert_match "Test file: test/bottles_test.rb", read_output

    modify_file('foo.rb')
    assert_match "Test file: foo_test.rb", read_output

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end

  def test_untracked_file
    create_file 'foo.rb', should_sleep: false
    create_file 'foo_test.rb', should_sleep: false

    launch_retest(@command)

    modify_file 'foo.rb'
    assert_match "Test file: foo_test.rb", read_output

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
  end
end
