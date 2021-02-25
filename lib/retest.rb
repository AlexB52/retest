require 'listen'
require 'string/similarity'

require "retest/version"
require "retest/runner"
require "retest/repository"
require "retest/test_options"
require "retest/options"
require "retest/version_control"

module Retest
  class Error < StandardError; end

  class << self
    def start(command)
      puts "Launching Retest..."

      build(
        runner: Runner.for(command),
        repository: Repository.new(files: VersionControl.files)
      ).start

      puts "Ready to refactor! You can make file changes now"
    end

    def build(runner:, repository:)
      Listen.to('.', only: /\.rb$/, relative: true) do |modified, added, removed|
        begin
          repository.remove(removed)
          repository.add(added)
          system('clear 2>/dev/null') || system('cls 2>/dev/null')

          runner.run repository.find_test (modified + added).first
        rescue => e
          puts "Something went wrong: #{e.message}"
        end
      end
    end
  end
end
