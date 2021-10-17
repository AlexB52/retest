require_relative 'runners/runner'
require_relative 'runners/test_runner'

module Retest
  module Runners
    module_function

    def runner_for(commamd)
      if commamd.include?('<test>')
        TestRunner
      else
        Runner
      end.new commamd
    end
  end
end