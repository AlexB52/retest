class SetupTest < Minitest::Test
  def test_repository_setup
    assert_equal :rspec, Retest::Setup.new.type
  end
end