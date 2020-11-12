require 'open3'

module Retest
  class Command
    def self.for(test_command)
      if test_command.include? '<test>'
        VariableCommand
      else
        HardcodedCommand
      end.new test_command
    end

    class VariableCommand
      attr_reader :command, :repository, :cached_test_file

      def initialize(command, repository: nil)
        @repository = repository || Repository.new
        @command = command
      end

      def ==(obj)
        command == obj.command
      end

      def run(file_changed)
        if @cached_test_file = test_file(file_changed)
          stdout_and_stderr_str, _ = Open3.capture2e command.gsub('<test>', cached_test_file)
          Retest.logger.puts "Test File Selected: #{cached_test_file}"
          Retest.logger.puts stdout_and_stderr_str
        else
          Retest.logger.puts <<~ERROR
            404 - Test File Not Found
            Retest could not find a matching test file to run.
          ERROR
        end
      end

      def test_file(file_changed)
        repository.find_test(file_changed) || cached_test_file
      end
    end

    HardcodedCommand = Struct.new(:command) do
      def run(_)
        stdout_and_stderr_str, _ = Open3.capture2e(command)
        Retest.logger.puts stdout_and_stderr_str
      end
    end
  end
end