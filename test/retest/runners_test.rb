require 'test_helper'

module Retest
  class RunnersTest < MiniTest::Test
    def test_runner_for
      assert_equal Runners::Runner.new('bundle exec rake test'), Runners.runner_for('bundle exec rake test')
      assert_equal Runners::TestRunner.new('bundle exec rake test TEST=<test>'), Runners.runner_for('bundle exec rake test TEST=<test>')
    end
  end
end