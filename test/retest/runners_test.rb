require 'test_helper'

module Retest
  class RunnersTest < MiniTest::Test
    def test_runner_for
      assert_equal Runners::Runner.new('bundle exec rake test'), Runners.runner_for('bundle exec rake test')
      assert_equal Runners::TestRunner.new('echo <test>'), Runners.runner_for('echo <test>')
      assert_equal Runners::ChangeRunner.new('echo <changed>'), Runners.runner_for('echo <changed>')
      assert_equal Runners::VariableRunner.new('echo <test> & <changed>'), Runners.runner_for('echo <test> & <changed>')
    end
  end
end