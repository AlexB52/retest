require_relative 'program/pausable'
require_relative 'program/forced_selection'

module Retest
  class Program
    extend Forwardable
    include Pausable
    include ForcedSelection

    attr_accessor :runner, :repository, :stdout

    def_delegators :runner,
      :run_last_command, :last_command

    def initialize(runner: nil, repository: nil, stdout: $stdout)
      @runner = runner
      @repository = repository
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
        @stdout.puts <<~HINT
          Forced selection enabled.
          Reset to default settings by typing 'r' in the interactive console.
        HINT

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
      runner.run(test_files: test_files)
    end

    def run_all
      runner.run_all
    end

    def force_batch(multiline_input)
      files = repository.find_tests multiline_input.split(/\s+/)

      force_selection(files)
      run(nil, force_run: true)
    end

    def clear_terminal
      system('clear 2>/dev/null') || system('cls 2>/dev/null')
    end
  end
end
