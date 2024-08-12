require_relative 'program/pausable'

module Retest
  class Program
    include Pausable

    attr_accessor :runner, :repository, :command
    def initialize(runner: nil, repository: nil, command: nil)
      @runner = runner
      @repository = repository
      @command = command
      initialize_pause(false)
    end

    def run(modified, added, removed)
      repository.sync(added: added, removed: removed)
      runner.sync(added: added, removed: removed)
      system('clear 2>/dev/null') || system('cls 2>/dev/null')

      runner.run (modified + added).first, repository: repository
    end

    def diff(branch)
      raise "Git not installed" unless VersionControl::Git.installed?
      test_files = repository.find_tests VersionControl::Git.diff_files(branch)

      puts "Tests found:"
      test_files.each { |test_file| puts "  - #{test_file}" }

      puts "Running tests..."
      runner.run_all_tests command.format_batch(*test_files)
    end
  end
end
