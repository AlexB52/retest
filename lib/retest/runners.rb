require_relative 'runners/runner'
require_relative 'runners/test_runner'
require_relative 'runners/change_runner'
require_relative 'runners/variable_runner'

module Retest
  module Runners
    module_function

    def runner_for(commamd)
      if commamd.include?('<test>') && commamd.include?('<changed>')
        VariableRunner
      elsif commamd.include?('<test>')
        TestRunner
      elsif commamd.include?('<changed>')
        ChangeRunner
      else
        Runner
      end.new commamd
    end
  end
end