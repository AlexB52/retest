class GracefulExitWhenInterrupting < Minitest::Test
  include RetestHelper

  def teardown
    end_retest
  end

  def test_interruption
    launch_retest 'retest --ruby'

    assert_output_matches <<~EXPECTED
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED

    Process.kill("INT", @pid) if @pid

    assert_output_matches "Goodbye"
  end
end
