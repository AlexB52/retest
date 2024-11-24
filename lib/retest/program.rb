require_relative 'program/pausable'

module Retest
  class Program
    include Pausable

    attr_accessor :runner, :repository, :command, :stdout
    def initialize(runner: nil, repository: nil, command: nil, clear_window: true, stdout: $stdout)
      @runner = runner
      @repository = repository
      @command = command
      @clear_window = clear_window
      @stdout = stdout
      initialize_pause(false)
    end

    def run(file, force_run: false)
      if paused? && !force_run
        @stdout.puts "Main program paused. Please resume program first."
        return
      end

      clear_terminal
      test_file = repository.find_test(file) if runner.command.test_type?
      runner.run changed_files: [file], test_files: [test_file]
    end

    def diff(branch)
      raise "Git not installed" unless VersionControl::Git.installed?
      test_files = repository.find_tests VersionControl::Git.diff_files(branch)

      @stdout.puts "Tests found:"
      test_files.each { |test_file| @stdout.puts "  - #{test_file}" }

      @stdout.puts "Running tests..."
      runner.run_all_tests command.format_batch(*test_files)
    end

    def clear_terminal
      return unless @clear_window

      system('clear 2>/dev/null') || system('cls 2>/dev/null')
    end
  end
end
