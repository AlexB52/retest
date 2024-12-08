class TestVersionFlag < Minitest::Test
  include RetestHelper

  def teardown
    end_retest
  end

  def test_version
    launch_retest 'retest --version'

    assert_output_matches /^2\.\d+\.\d+/
  end

  def test_version_short_flag
    launch_retest 'retest -v'

    assert_output_matches /^2\.\d+\.\d+/
  end
end
