class TestHelpFlag < Minitest::Test
  def test_help
    @output, @pid = launch_retest 'retest --help'

    assert_match <<~EXPECTED, @output.read
      Usage: retest  [OPTIONS] [COMMAND]

      Watch a file change and run it matching spec.
    EXPECTED
  end

  def test_help_short_flag
    @output, @pid = launch_retest 'retest -h'

    assert_match <<~EXPECTED, @output.read
      Usage: retest  [OPTIONS] [COMMAND]

      Watch a file change and run it matching spec.
    EXPECTED
  end
end
