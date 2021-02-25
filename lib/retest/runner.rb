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

      def cached_test_file
        @cached_test_file
      end

      def cached_test_file=(value)
        @cached_test_file = value || @cached_test_file
      end

      def run(test_file = nil)
        self.cached_test_file = test_file

        if cached_test_file
          puts "Test File Selected: #{cached_test_file}"
          system command.gsub('<test>', cached_test_file)
        else
          puts <<~ERROR
            404 - Test File Not Found
            Retest could not find a matching test file to run.
          ERROR
        end
      end

      def remove(purged)
        return if purged.empty?

        if purged.is_a? Array
          purge_cache if purged.include? cached_test_file
        elsif purged.is_a? String
          purge_cache if purged == cached_test_file
        end
      end

      private

      def purge_cache
        @cached_test_file = nil
      end
    end

    HardcodedRunner = Struct.new(:command) do
      def run(_ = nil)
        system command
      end

      def remove(_ = nil); end
    end
  end
end