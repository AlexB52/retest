class MatchingUnmatchingCommandTest < Minitest::Test
  def setup
    create_file('test/other_bottles_test.rb', should_sleep: false)
  end

  def teardown
    end_retest
    delete_file('test/other_bottles_test.rb')
  end

  def test_not_displaying_options_on_unmatching_command
    launch_retest "retest 'echo there was no command'"

    modify_file('lib/bottles.rb')

    refute_match "We found few tests matching:", @output.read
    assert_match "there was no command", @output.read
  end

  def test_displaying_options_on_matching_command
    launch_retest('retest --ruby')

    create_file 'foo_test.rb'
    assert_match "Test file: foo_test.rb", @output.read

    modify_file('lib/bottles.rb')
    assert_match <<~EXPECTED.chomp, @output.read
      We found few tests matching: lib/bottles.rb

      [0] - test/bottles_test.rb
      [1] - test/other_bottles_test.rb
      [2] - none

      Which file do you want to use?
      Enter the file number now:
      >
    EXPECTED

    @input.write "2\n"
    wait

    assert_match "Test file: foo_test.rb", @output.read

  ensure
    delete_file 'foo_test.rb'
  end
end
