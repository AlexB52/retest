require_relative "runner/cached_test_file"

module Retest
  class Runner
    extend Forwardable
    include Observable
    include CachedTestFile

    def_delegators :command,
      :has_changed?, :has_test?,
      :changed_type?, :test_type?, :variable_type?, :harcoded_type?

    attr_accessor :command, :stdout, :last_command
    def initialize(command, stdout: $stdout)
      @stdout  = stdout
      @command = command
    end

    def run_last_command
      system_run last_command
    end

    def run(changed_files: [], test_files: [])
      self.last_command = format_instruction(changed_files: changed_files, test_files: test_files)
      system_run last_command
    rescue FileNotFound => e
      log("FileNotFound - #{e.message}")
    rescue Command::MultipleTestsNotSupported => e
      log("Command::MultipleTestsNotSupported - #{e.message}")
    end

    def run_all
      self.last_command = command.clone(all: true).to_s
      system_run last_command
    end

    def format_instruction(changed_files: [], test_files: [])
      if changed_files.empty? && test_files.size >= 1
        instruction = command.clone(all: false).to_s
        tests_string = command.format_batch(*test_files)
        log("Tests selected:")
        test_files.each { |test_file| log("  - #{test_file}") }
        return instruction.gsub('<test>', tests_string)
      end

      instruction = command.to_s
      instruction = format_changed_files(instruction: instruction, files: changed_files)
      instruction = format_test_files(instruction: instruction, files: test_files)
    end

    def format_test_files(instruction:, files:)
      return instruction unless has_test?

      self.cached_test_file = files.first

      if cached_test_file.nil?
        raise FileNotFound, "Retest could not find a matching test file to run."
      end

      log("Test file: #{cached_test_file}")
      instruction.gsub('<test>', cached_test_file)
    end

    def format_changed_files(instruction:, files:)
      return instruction unless has_changed?
      changed_file = files.first

      if changed_file.nil?
        raise FileNotFound, "Retest could not find a changed file to run."
      end

      log("Changed file: #{changed_file}")
      instruction.gsub('<changed>', changed_file)
    end

    def sync(added:, removed:)
      purge_test_file(removed)
    end

    private

    def print_test_file_not_found
      log(<<~ERROR)
        FileNotFound - Retest could not find a matching test file to run.
      ERROR
    end

    def system_run(command)
      log("\n")
      result = system(command) ? :tests_pass : :tests_fail
      changed
      notify_observers(result)
    end

    def log(message)
      stdout.puts(message)
    end
  end
end
