module Retest
  class Command
    def self.for(test_command)
      command_class = if test_command.include? '<test>'
        VariableCommand
      else
        HardcodedCommand
      end

      command_class.new test_command
    end

    class VariableCommand
      attr_reader :command, :repository

      def initialize(command, repository: nil)
        @repository = repository || Repository.new
        @command = command
      end

      def ==(obj)
        command == obj.command
      end

      def run(file_changed)
        if repository.find_test(file_changed)
          puts "Test File Selected: #{repository.find_test(file_changed)}"
          system command.gsub('<test>', repository.find_test(file_changed))
        else
          puts 'Could not find a file test matching'
        end
      end
    end

    HardcodedCommand = Struct.new(:command) do
      def run(file_changed)
        system command
      end
    end
  end
end