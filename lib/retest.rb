require 'listen'
require 'string/similarity'

require "retest/version"
require "retest/runner"
require "retest/repository"
require "retest/test_options"
require "retest/listen_options"
require "retest/options"

module Retest
  class Error < StandardError; end

  class << self
    def start(command)
      puts "Launching Retest..."

      build(
        runner: Runner.for(command),
        repository: Repository.new
      ).start

      puts "Ready to refactor! You can make file changes now"
    end

    def build(runner:, repository:)
      Listen.to('.', ListenOptions.to_h) do |modified, added, removed|
        begin
          if modified.any?
            system('clear 2>/dev/null') || system('cls 2>/dev/null')
            runner.run repository.find_test(modified.first.strip)
          elsif added.any?
            # add added to files then run
            runner.run(added.first.strip)
          end
        rescue => e
          puts "Something went wrong: #{e.message}"
        end
      end
    end
  end
end
