class TestVersionFlag < Minitest::Test
  def teardown
    end_retest
  end

  def test_version
    launch_retest 'retest --version'

    assert_match /^2\.\d+\.\d+/, @output.read
  end

  def test_version_short_flag
    launch_retest 'retest -v'

    assert_match /^2\.\d+\.\d+/, @output.read
  end
end
