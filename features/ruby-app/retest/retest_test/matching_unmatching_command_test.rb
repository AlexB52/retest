class MatchingUnmatchingCommandTest < Minitest::Test
  def setup
    create_file('test/other_bottles_test.rb', should_sleep: false)
  end

  def teardown
    end_retest @output, @pid
    delete_file('test/other_bottles_test.rb')
  end

  def test_not_displaying_options_on_unmatching_command
    @output, @pid = launch_retest "retest 'echo there was no command'"

    modify_file('lib/bottles.rb')

    refute_match "We found few tests matching:", @output.read
    assert_match "there was no command", @output.read
  end

  def test_displaying_options_on_matching_command
    @output, @pid = launch_retest 'retest --ruby'

    modify_file('lib/bottles.rb')

    assert_match <<~EXPECTED, @output.read
      We found few tests matching: lib/bottles.rb
      [0] - test/bottles_test.rb
      [1] - test/other_bottles_test.rb

      Which file do you want to use?
      Enter the file number now:
    EXPECTED
  end
end