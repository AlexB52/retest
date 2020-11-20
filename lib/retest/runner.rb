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
          puts "Test File Selected: #{cached_test_file}"
          system command.gsub('<test>', cached_test_file)
        else
          puts <<~ERROR
            404 - Test File Not Found
            Retest could not find a matching test file to run.
          ERROR
        end
      end

      def test_file(file_changed)
        repository.find_test(file_changed) || cached_test_file
      end
    end

    HardcodedRunner = Struct.new(:command) do
      def run(_)
        system command
      end
    end
  end
end