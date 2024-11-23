require_relative 'runners/runner'
require_relative 'runners/test_runner'
require_relative 'runners/change_runner'
require_relative 'runners/variable_runner'

module Retest
  module Runners
    class NotSupportedError < StandardError; end

    module_function

    def runner_for(command, **opts)
      for_test   = command.to_s.include?('<test>')
      for_change = command.to_s.include?('<changed>')

      if for_test && for_change then VariableRunner
      elsif for_test            then TestRunner
      elsif for_change          then ChangeRunner
      else                           Runner
      end.new command, **opts
    end
  end
end