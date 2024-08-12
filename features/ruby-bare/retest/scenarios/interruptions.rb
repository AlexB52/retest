class GracefulExitWhenInterrupting < Minitest::Test
  def teardown
    end_retest
  end

  def test_interruption
    launch_retest 'retest --ruby'

    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED

    Process.kill("INT", @pid)
    wait

    assert_match <<~EXPECTED, @output.read
      Goodbye
    EXPECTED
  end
end
