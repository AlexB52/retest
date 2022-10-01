class FileChangesTest < Minitest::Test
  def setup
    @command = 'retest'
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

    modify_file('lib/bundler_app/bottles.rb')

    assert_match "Test File Selected: test/bundler_app/test_bottles.rb", @output.read
    assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end

  def test_modifying_existing_test_file
    @output, @pid = launch_retest @command

    modify_file('test/bundler_app/test_bottles.rb')

    assert_match "Test File Selected: test/bundler_app/test_bottles.rb", @output.read
    assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", @output.read
  end

  def test_creating_a_new_test_file
    @output, @pid = launch_retest @command

    create_file 'test/bundler_app/test_foo.rb'

    assert_match "Test File Selected: test/bundler_app/test_foo.rb", @output.read

    delete_file 'test/bundler_app/test_foo.rb'
  end

  def test_creating_a_new_file
    @output, @pid = launch_retest @command

    create_file 'lib/bundler_app/foo.rb'
    assert_match <<~EXPECTED, @output.read
      404 - Test File Not Found
      Retest could not find a matching test file to run.
    EXPECTED

    create_file 'test/bundler_app/test_foo.rb'
    assert_match "Test File Selected: test/bundler_app/test_foo.rb", @output.read

    modify_file('lib/bundler_app/bottles.rb')
    assert_match "Test File Selected: test/bundler_app/test_bottles.rb", @output.read

    modify_file('lib/bundler_app/foo.rb')
    assert_match "Test File Selected: test/bundler_app/test_foo.rb", @output.read

    delete_file 'lib/bundler_app/foo.rb'
    delete_file 'test/bundler_app/test_foo.rb'
  end

  def test_untracked_file
    create_file 'lib/bundler_app/foo.rb', should_sleep: false
    create_file 'test/bundler_app/test_foo.rb', should_sleep: false

    @output, @pid = launch_retest @command

    modify_file 'lib/bundler_app/foo.rb'
    assert_match "Test File Selected: test/bundler_app/test_foo.rb", @output.read

    delete_file 'lib/bundler_app/foo.rb'
    delete_file 'test/bundler_app/test_foo.rb'
  end
end
