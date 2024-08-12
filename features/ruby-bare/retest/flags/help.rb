class TestHelpFlag < Minitest::Test
  def teardown
    end_retest
  end

  def test_help
    launch_retest 'retest --help'

    assert_match <<~EXPECTED, @output.read
      Usage: retest  [OPTIONS] [COMMAND]

      Watch a file change and run it matching spec.
    EXPECTED
  end

  def test_help_short_flag
    launch_retest 'retest -h'

    assert_match <<~EXPECTED, @output.read
      Usage: retest  [OPTIONS] [COMMAND]

      Watch a file change and run it matching spec.
    EXPECTED
  end
end
