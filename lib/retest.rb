require 'listen'
require 'string/similarity'

require "retest/version"
require "retest/runner"
require "retest/repository"
require "retest/test_options"
require "retest/options"
require "retest/version_control"
require "retest/setup"

module Retest
  class Error < StandardError; end

  class << self
    def diff(branch:, repository:, runner:)
      raise "Git not installed" unless VersionControl::Git.installed?
      git = VersionControl::Git.new

      test_files = repository.find_tests git.diff_files(branch)

      puts "Tests found:"
      test_files.each { |test_file| puts "  - #{test_file}" }

      puts "Running tests..."
      test_files.each { |test_file| runner.run test_file }
    end

    def start(runner:, repository:)
      puts "Launching Retest..."
      build(runner: runner, repository: repository).start
      puts "Ready to refactor! You can make file changes now"
    end

    def build(runner:, repository:)
      Listen.to('.', only: /\.rb$/, relative: true) do |modified, added, removed|
        begin
          repository.add(added)
          repository.remove(removed)
          runner.remove(removed)
          system('clear 2>/dev/null') || system('cls 2>/dev/null')

          runner.run repository.find_test (modified + added).first
        rescue => e
          puts "Something went wrong: #{e.message}"
        end
      end
    end
  end
end
