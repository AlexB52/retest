class InteractiveCommandTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest'
  end

  def teardown
    end_retest
  end

  def test_start_help
    launch_retest @command

    assert_output_matches <<~EXPECTED.chomp
      Setup: [RAKE]
      Command: 'bundle exec rake test TEST=<test>'
      Watcher: [LISTEN]

      Launching Retest...
      Ready to refactor! You can make file changes now

      Type interactive command and press enter. Enter 'h' for help.
      >\s
    EXPECTED

    write_input("h\n")

    assert_output_matches <<~EXPECTED.chomp
      Commands:
        <ENTER>                Run last changed triggered command
        h, help                Show help
        p, pause               Pause Retest (tests won't run on file changes)
        u, unpause             Unpause Retest
        ra, run all            Run all tests
        f, force               Force a selection of tests to run on every file change
        fb, force batch        Force a selection of tests based on raw data list
        r, reset               Reset forced selection
        d, diff [BRANCH]       Run specs changed relative to a Git branch
        c, clear               Clear the window
        e, exit                Exit Retest

      Type interactive command and press enter. Enter 'h' for help.
      >\s
    EXPECTED
  end

  def test_pause_unpause
    launch_retest @command

    modify_file('lib/bundler_app/bottles.rb')

    assert_output_matches(
      "Test file: test/bundler_app/test_bottles.rb",
      "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips"
    )

    write_input("p\n")

    assert_output_matches "Program is paused"

    modify_file('lib/bundler_app/bottles.rb')

    assert_output_matches <<~EXPECTED
      File changed: lib/bundler_app/bottles.rb
      Main program paused. Please resume program first.
    EXPECTED

    write_input("\n") # Manually run previous test

    assert_output_matches(
      "Running last command: 'bundle exec rake test TEST=test/bundler_app/test_bottles.rb'",
      "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips"
    )

    write_input("u\n")

    modify_file('lib/bundler_app/bottles.rb')

    assert_output_matches(
      "Test file: test/bundler_app/test_bottles.rb",
      "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips"
    )
  end

  def test_force_reset
    launch_retest @command

    write_input("f\n")

    assert_output_matches "What test files do you want to run when saving a file? (min. 1)"

    write_input("fib\s\n")

    assert_output_matches <<~EXPECTED
      Forced selection enabled.
      Reset to default settings by typing 'r' in the interactive console.

      Tests selected:
        - test/bundler_app/test_fibonacci.rb
    EXPECTED

    assert_output_matches "8 runs, 9 assertions, 0 failures, 0 errors, 0 skips"

    modify_file('lib/bundler_app/bottles.rb')

    assert_output_matches <<~EXPECTED
      Forced selection enabled.
      Reset to default settings by typing 'r' in the interactive console.

      Tests selected:
        - test/bundler_app/test_fibonacci.rb
    EXPECTED

    write_input("\n") # Manually run previous test

    assert_output_matches(
      "Running last command: 'bundle exec rake test TEST=test/bundler_app/test_fibonacci.rb'",
      "8 runs, 9 assertions, 0 failures, 0 errors, 0 skips"
    )

    write_input("r\n")

    modify_file('lib/bundler_app/bottles.rb')

    assert_output_matches(
      "Test file: test/bundler_app/test_bottles.rb",
      "12 runs, 12 assertions, 0 failures, 0 errors, 0 skips")
  end

  def test_force_batch
    launch_retest @command

    write_input("fb\n")

    assert_output_matches "Enter list of test files to run"

    write_input("test/test_bundler_app.rb\s\n")
    write_input("test/bundler_app/test_fibonacci.rb")
    write_input("\C-d")

    assert_output_matches <<~EXPECTED
      Forced selection enabled.
      Reset to default settings by typing 'r' in the interactive console.

      Tests selected:
        - test/bundler_app/test_fibonacci.rb
        - test/test_bundler_app.rb
    EXPECTED

    assert_output_matches "9 runs, 10 assertions, 0 failures, 0 errors, 0 skips"
  end

  def test_force_batch_with_no_results
    launch_retest @command

    write_input("fb\n")

    assert_output_matches "Enter list of test files to run"

    write_input("test/hello.rb\s\n")
    write_input("lib/greetings.rb  lib/world.rb")
    write_input("\C-d")

    assert_output_matches <<~EXPECTED
      Retest could not find matching tests for these inputs:
        - test/hello.rb
        - lib/greetings.rb
        - lib/world.rb

      No test files found

    EXPECTED
  end

  def test_force_batch_with_mixed_results
    launch_retest @command

    write_input("fb\n")

    assert_output_matches "Enter list of test files to run"

    write_input(<<~INPUT)
        test/test_bundler_app.rb
      test/bundler_app/test_fibonacci.rb
      test/hello.rb lib/greetings.rb lib/world.rb
      \C-d
    INPUT

    assert_output_matches <<~EXPECTED
      Retest could not find matching tests for these inputs:
        - test/hello.rb
        - lib/greetings.rb
        - lib/world.rb

      Forced selection enabled.
      Reset to default settings by typing 'r' in the interactive console.

      Tests selected:
        - test/bundler_app/test_fibonacci.rb
        - test/test_bundler_app.rb
    EXPECTED

    assert_output_matches "9 runs, 10 assertions, 0 failures, 0 errors, 0 skips"
  end

  def test_run_all
    launch_retest @command

    write_input("ra\n")

    assert_output_matches(
      "Running all tests",
      "21 runs, 22 assertions, 0 failures, 0 errors, 0 skips")

    write_input("\n") # Manually run previous test

    assert_output_matches(
      "Running last command: 'bundle exec rake test",
      "21 runs, 22 assertions, 0 failures, 0 errors, 0 skips")
  end
end
