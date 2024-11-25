require_relative 'program/pausable'
require_relative 'program/forced_selection'

module Retest
  class Program
    include Pausable
    include ForcedSelection

    attr_accessor :runner, :repository, :stdout
    def initialize(runner: nil, repository: nil, clear_window: true, stdout: $stdout)
      @runner = runner
      @repository = repository
      @clear_window = clear_window
      @stdout = stdout
      initialize_pause(false)
      initialize_forced_selection([])
    end

    def run(file, force_run: false)
      if paused? && !force_run
        @stdout.puts "Main program paused. Please resume program first."
        return
      end

      if forced_selection?
        runner.run(test_files: selected_test_files)
        return
      end

      test_file = if runner.has_test?
        repository.find_test(file)
      end

      runner.run changed_files: [file], test_files: [test_file]
    end

    def diff(branch)
      raise "Git not installed" unless VersionControl::Git.installed?

      test_files = repository.find_tests VersionControl::Git.diff_files(branch)
      run_selected(test_files)
    end

    def run_all
      runner.run_all
    end

    def run_selected(test_files)
      runner.run(test_files: test_files)
    end

    def clear_terminal
      return unless @clear_window

      system('clear 2>/dev/null') || system('cls 2>/dev/null')
    end
  end
end
