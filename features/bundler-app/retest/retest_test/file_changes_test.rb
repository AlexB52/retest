class FileChangesTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest'
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

    modify_file('lib/bundler_app/bottles.rb')

    assert_output_matches(
      'Test file: test/bundler_app/test_bottles.rb',
      '12 runs, 12 assertions, 0 failures, 0 errors, 0 skips')
  end

  def test_modifying_existing_test_file
    launch_retest @command

    modify_file('test/bundler_app/test_bottles.rb')

    assert_output_matches(
      'Test file: test/bundler_app/test_bottles.rb',
      '12 runs, 12 assertions, 0 failures, 0 errors, 0 skips')
  end

  def test_creating_a_new_test_file
    launch_retest @command

    create_file 'test/bundler_app/test_foo.rb'

    assert_output_matches 'Test file: test/bundler_app/test_foo.rb'

  ensure
    delete_file 'test/bundler_app/test_foo.rb'
  end

  def test_creating_a_new_file
    launch_retest @command

    create_file 'lib/bundler_app/foo.rb'
    assert_output_matches 'FileNotFound - Retest could not find a matching test file to run.'

    create_file 'test/bundler_app/test_foo.rb'
    assert_output_matches 'Test file: test/bundler_app/test_foo.rb'

    modify_file('lib/bundler_app/bottles.rb')
    assert_output_matches 'Test file: test/bundler_app/test_bottles.rb'

    modify_file('lib/bundler_app/foo.rb')
    assert_output_matches 'Test file: test/bundler_app/test_foo.rb'

  ensure
    delete_file 'lib/bundler_app/foo.rb'
    delete_file 'test/bundler_app/test_foo.rb'
  end

  def test_untracked_file
    create_file 'lib/bundler_app/foo.rb', sleep_for: 0
    create_file 'test/bundler_app/test_foo.rb', sleep_for: 0

    launch_retest @command

    modify_file 'lib/bundler_app/foo.rb'
    assert_output_matches 'Test file: test/bundler_app/test_foo.rb'

  ensure
    delete_file 'lib/bundler_app/foo.rb'
    delete_file 'test/bundler_app/test_foo.rb'
  end
end
