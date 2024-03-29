require_relative 'runners/runner'
require_relative 'runners/test_runner'
require_relative 'runners/change_runner'
require_relative 'runners/variable_runner'

module Retest
  module Runners
    module_function

    def runner_for(command)
      for_test   = command.include?('<test>')
      for_change = command.include?('<changed>')

      if for_test && for_change then VariableRunner
      elsif for_test            then TestRunner
      elsif for_change          then ChangeRunner
      else                           Runner
      end.new command
    end
  end
end