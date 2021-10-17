require_relative 'runners/runner'
require_relative 'runners/test_runner'
require_relative 'runners/change_runner'
require_relative 'runners/variable_runner'

module Retest
  module Runners
    module_function

    def runner_for(command)
      if command.include?('<test>') && command.include?('<changed>')
        VariableRunner
      elsif command.include?('<test>')
        TestRunner
      elsif command.include?('<changed>')
        ChangeRunner
      else
        Runner
      end.new command
    end
  end
end