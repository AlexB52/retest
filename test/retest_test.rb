require "test_helper"

class RetestTest < Minitest::Test
  include Retest

  def test_that_it_has_a_version_number
    refute_nil ::Retest::VERSION
  end
end
