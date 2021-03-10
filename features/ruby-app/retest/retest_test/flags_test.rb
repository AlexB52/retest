class FlagTest < Minitest::Test
  def setup
  end

  def teardown
    end_retest @output, @pid
  end

  def test_with_no_command
    @output, @pid = launch_retest 'retest'

    modify_file('lib/bottles.rb')

    assert_match "You have no command assigned", @output.read
  end
end