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
end

# Testing a new way to launch and interact with retest
class TestMatchingUnmatchingCommand < Minitest::Test
  include FileHelper

  def setup
    create_file('test/other_bottles_test.rb', should_sleep: false)
  end

  def teardown
    delete_file('test/other_bottles_test.rb')
  end

  def launch_retest(command, input: Tempfile.new, output: Tempfile.new)
    pid = Process.spawn(command, in: input, out: output)
    sleep 1.5

    [pid, input.tap(&:rewind), output.tap(&:rewind)]
  end

  def end_retest(pid:, input:, output:)
    input.close
    input.unlink
    output.close
    output.unlink
    Process.kill('SIGHUP', pid)
    Process.detach(pid)
  end

  def test_displaying_options_on_matching_command
    stdin = Tempfile.new
    stdin.write "2\n"
    pid, _, stdout = launch_retest('retest --ruby', input: stdin)

    create_file 'foo_test.rb'
    assert_match "Test File Selected: foo_test.rb", stdout.tap(&:rewind).read

    modify_file('lib/bottles.rb')
    assert_match <<~EXPECTED.chomp, stdout.tap(&:rewind).read
      We found few tests matching: lib/bottles.rb

      [0] - test/bottles_test.rb
      [1] - test/other_bottles_test.rb
      [2] - none

      Which file do you want to use?
      Enter the file number now:
      > 
    EXPECTED

    assert_match "Test File Selected: foo_test.rb", stdout.tap(&:rewind).read
  ensure
    end_retest(pid: pid, input: stdin, output: stdout)
  end
end
