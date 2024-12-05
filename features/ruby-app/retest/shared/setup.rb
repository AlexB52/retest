module Setup
  def test_repository_setup
    assert_equal :ruby, Retest::Setup.new.type
  end
end
