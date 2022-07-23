class GracefulExitWhenInterrupting < Minitest::Test
  def teardown
    end_retest @output, @pid
  end

  def test_interruption
    @output, @pid = launch_retest 'retest --ruby'

    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED

    Process.kill("INT", @pid)
    sleep 1

    assert_match <<~EXPECTED, @output.read
      Goodbye
    EXPECTED
  end
end
