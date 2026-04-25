class TestHelpFlag < Minitest::Test
  include RetestHelper

  def teardown
    end_retest
  end

  def test_help
    launch_retest 'retest --help'

    assert_output_matches <<~EXPECTED
      Usage: retest [options] [COMMAND]

      Watch files and rerun matching tests when they change.
    EXPECTED
  end

  def test_help_short_flag
    launch_retest 'retest -h'

    assert_output_matches <<~EXPECTED
      Usage: retest [options] [COMMAND]

      Watch files and rerun matching tests when they change.
    EXPECTED
  end
end
