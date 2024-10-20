require 'test_helper'

module Retest
  class SetupTest < Minitest::Test
    def setup
      @subject = Setup.new
    end

    def test_repo_is_a_rake_setup
      assert_equal :rake, @subject.type
    end
  end
end