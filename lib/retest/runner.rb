require_relative "runner/cached_test_file"

module Retest
  class Runner
    extend Forwardable
    include Observable
    include CachedTestFile

    def_delegators :command, :has_changed?, :has_test?

    attr_accessor :command, :stdout, :last_command
    def initialize(command, stdout: $stdout)
      @stdout  = stdout
      @command = command
      if command.hardcoded?
        self.last_command = command.to_s
      end
    end

    def run_last_command
      unless last_command
        return log('Error - Not enough information to run a command. Please trigger a run first.')
      end

      system_run last_command
    end

    def run(changed_files: [], test_files: [])
      self.last_command = format_instruction(changed_files: changed_files, test_files: test_files)
      run_last_command
    rescue FileNotFound => e
      log("FileNotFound - #{e.message}")
    rescue Command::MultipleTestsNotSupported => e
      log("Command::MultipleTestsNotSupported - #{e.message}")
    end

    def run_all
      self.last_command = command.switch_to(:all).to_s
      run_last_command
    rescue Command::AllTestsNotSupported => e
      log("Command::AllTestsNotSupported - #{e.message}")
    end

    def format_instruction(changed_files: [], test_files: [])
      if changed_files.empty? && test_files.size >= 1
        new_command = command.switch_to(:batched)

        log("Tests selected:")
        test_files.each { |test_file| log("  - #{test_file}") }

        return new_command.to_s.gsub('<test>', new_command.format_batch(*test_files))
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
