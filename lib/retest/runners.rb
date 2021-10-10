require_relative 'runners/runner'
require_relative 'runners/hardcoded_runner'
require_relative 'runners/variable_runner'

module Retest
  module Runners
    module_function

    def runner_for(commamd)
      if test_command.include? '<test>'
        VariableRunner
      else
        HardcodedRunner
      end.new test_command
    end
  end
end