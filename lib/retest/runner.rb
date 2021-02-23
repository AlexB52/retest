module Retest
  class Runner
    def self.for(test_command)
      if test_command.include? '<test>'
        VariableRunner
      else
        HardcodedRunner
      end.new test_command
    end

    class VariableRunner
      attr_reader :command

      def initialize(command)
        @command = command
        @cached_test_file = nil
      end

      def ==(obj)
        command == obj.command
      end

      def run(test_file = nil)
        if @cached_test_file = test_file || @cached_test_file
          puts "Test File Selected: #{@cached_test_file}"
          system command.gsub('<test>', @cached_test_file)
        else
          puts <<~ERROR
            404 - Test File Not Found
            Retest could not find a matching test file to run.
          ERROR
        end
      end
    end

    HardcodedRunner = Struct.new(:command) do
      def run(_ = nil)
        system command
      end
    end
  end
end