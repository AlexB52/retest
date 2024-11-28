class FlagTest < Minitest::Test
  def setup
  end

  def teardown
    end_retest
  end

  def test_with_no_command
    launch_retest 'retest'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RUBY]. Using command: 'bundle exec ruby <test>'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('lib/bottles.rb')

    assert_match "Test file: test/bottles_test.rb", @output.read
  end
end