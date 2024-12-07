class FileChangesTest < Minitest::Test
  include FileHelper
  include OutputHelper
  include CommandHelper

  def setup
    @command = 'retest'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_match <<~EXPECTED, read_output
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modifying_existing_file
    launch_retest @command

    modify_file('lib/bundler_app/bottles.rb')

    read_output do |output|
      assert_match "Test file: test/bundler_app/test_bottles.rb", output
      assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", output
    end
  end

  def test_modifying_existing_test_file
    launch_retest @command

    modify_file('test/bundler_app/test_bottles.rb')

    read_output do |output|
      assert_match "Test file: test/bundler_app/test_bottles.rb", output
      assert_match "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips", output
    end
  end

  def test_creating_a_new_test_file
    launch_retest @command

    create_file 'test/bundler_app/test_foo.rb'

    assert_match "Test file: test/bundler_app/test_foo.rb", read_output

  ensure
    delete_file 'test/bundler_app/test_foo.rb'
  end

  def test_creating_a_new_file
    launch_retest @command

    create_file 'lib/bundler_app/foo.rb'
    assert_match <<~EXPECTED, read_output
      FileNotFound - Retest could not find a matching test file to run.
    EXPECTED

    create_file 'test/bundler_app/test_foo.rb'
    assert_match "Test file: test/bundler_app/test_foo.rb", read_output

    modify_file('lib/bundler_app/bottles.rb')
    assert_match "Test file: test/bundler_app/test_bottles.rb", read_output

    modify_file('lib/bundler_app/foo.rb')
    assert_match "Test file: test/bundler_app/test_foo.rb", read_output

  ensure
    delete_file 'lib/bundler_app/foo.rb'
    delete_file 'test/bundler_app/test_foo.rb'
  end

  def test_untracked_file
    create_file 'lib/bundler_app/foo.rb', should_sleep: false
    create_file 'test/bundler_app/test_foo.rb', should_sleep: false

    launch_retest @command

    modify_file 'lib/bundler_app/foo.rb'
    assert_match "Test file: test/bundler_app/test_foo.rb", read_output

  ensure
    delete_file 'lib/bundler_app/foo.rb'
    delete_file 'test/bundler_app/test_foo.rb'
  end
end
