class TestVersionFlag < Minitest::Test
  def test_version
    @output, @pid = launch_retest 'retest --version'

    assert_match /^1\.\d+\.\d+/, @output.read
  end

  def test_version_short_flag
    @output, @pid = launch_retest 'retest -v'

    assert_match /^1\.\d+\.\d+/, @output.read
  end
end
