require_relative "runner/cached_test_file"

module Retest
  class Runner
    include Observable
    include CachedTestFile

    attr_accessor :command, :stdout
    def initialize(command, stdout: $stdout)
      @stdout  = stdout
      @command = command
    end

    def ==(obj)
      return false unless obj.command

      command.to_s == obj.command.to_s && self.class == obj.class
    end

    def run(changed_files: [], test_files: [])
      changed_file = changed_files.is_a?(Array) ? changed_files.first : changed_files
      test_file    = test_files.is_a?(Array)    ? test_files.first    : test_files

      self.cached_test_file = test_file

      if command.to_s.include?('<changed>')
        if changed_file.nil?
          print_changed_file_not_found
          return
        end
        log("Changed file: #{changed_file}")
      end

      if command.to_s.include?('<test>')
        if cached_test_file.nil?
          print_test_file_not_found
          return
        end
        log("Test file: #{cached_test_file}")
      end

      log("\n")
      system_run command.to_s
        .gsub('<test>', cached_test_file.to_s)
        .gsub('<changed>', changed_file.to_s)
    end

    def run_all_tests(tests_string)
      log("Test Files Selected: #{tests_string}")
      system_run command.to_s.gsub('<test>', tests_string)
    end

    def sync(added:, removed:)
      purge_test_file(removed)
    end

    def running?
      @running
    end

    private

    def system_run(command)
      @running = true
      result = system(command) ? :tests_pass : :tests_fail
      changed
      notify_observers(result)
      @running = false
    end

    def log(message)
      stdout.puts(message)
    end

    def print_changed_file_not_found
      log(<<~ERROR)
        FileNotFound - Retest could not find a changed file to run.
      ERROR
    end

    def print_test_file_not_found
      log(<<~ERROR)
        FileNotFound - Retest could not find a matching test file to run.
      ERROR
    end
  end
end
