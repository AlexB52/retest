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
      @run_mutex = Mutex.new
      @running = false
      @queued_file = nil
      initialize_pause(false)
      initialize_forced_selection([])
    end

    def run(file, force_run: false)
      started = start_run(file)
      return unless started

      current_file = file
      current_force_run = force_run
      completed = false

      loop do
        run_now(current_file, force_run: current_force_run)

        next_file = next_queued_file_or_finish
        break unless next_file

        current_file = next_file
        current_force_run = false
      end
      completed = true
    ensure
      finish_run if started && !completed
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
      failures, successes = repository
        .search_tests(multiline_input.split(/\s+/))
        .partition { |k,v| v.nil? }

      Output.force_batch_failures(failures.map(&:first), out: @stdout)

      if (successes = successes.to_h).empty?
        @stdout.puts "No test files found"
      else
        force_selection(successes.values.uniq.compact.sort)
        run(nil, force_run: true)
      end
    end

    def clear_terminal
      system('clear 2>/dev/null') || system('cls 2>/dev/null')
    end

    private

    def run_now(file, force_run: false)
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

    def start_run(file)
      @run_mutex.synchronize do
        if @running
          @queued_file = file
          return false
        end

        @running = true
      end
    end

    def next_queued_file_or_finish
      @run_mutex.synchronize do
        if @queued_file
          @queued_file.tap { @queued_file = nil }
        else
          @running = false
          nil
        end
      end
    end

    def finish_run
      @run_mutex.synchronize do
        @running = false
        @queued_file = nil
      end
    end
  end
end
