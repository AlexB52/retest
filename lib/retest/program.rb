require_relative 'program/pausable'

module Retest
  class Program
    include Pausable

    attr_accessor :runner, :repository, :command
    def initialize(runner: nil, repository: nil, command: nil, clear_window: true)
      @runner = runner
      @repository = repository
      @command = command
      @clear_window = clear_window
      initialize_pause(false)
    end

    def run(modified, added, removed)
      repository.sync(added: added, removed: removed)
      runner.sync(added: added, removed: removed)

      return if paused?

      clear_terminal
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

    private

    def clear_terminal
      return unless @clear_window

      system('clear 2>/dev/null') || system('cls 2>/dev/null')
    end
  end
end
