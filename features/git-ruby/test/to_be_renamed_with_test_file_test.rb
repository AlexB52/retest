gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require 'minitest/pride'

class ToBeRenamedWithTestFile < Minitest::Test
  def test_the_truth
    assert true
  end
end
