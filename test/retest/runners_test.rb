require 'test_helper'

module Retest
  class RunnersTest < MiniTest::Test
    def test_runner_for
      skip
      command = Command::Rake.new(all: true)
      assert_equal Runners::Runner.new('bundle exec rake test'), Runners.runner_for(command)

      command = Command::Hardcoded.new(command: 'echo <test>')
      assert_equal Runners::TestRunner.new('echo <test>'), Runners.runner_for(command)

      command = Command::Hardcoded.new(command: 'echo <changed>')
      assert_equal Runners::ChangeRunner.new('echo <changed>'), Runners.runner_for(command)

      command = Command::Hardcoded.new(command: 'echo <test> & <changed>')
      assert_equal Runners::VariableRunner.new('echo <test> & <changed>'), Runners.runner_for(command)
    end
  end
end