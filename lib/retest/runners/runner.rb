module Retest
  module Runners
    class Runner
      attr_accessor :command
      def initialize(command)
        @command = command
      end

      def ==(obj)
        command == obj.command && obj.class == self.class
      end

      def run(changed_file = nil, repository: nil)
        system_run command
      end

      def run_all_tests(tests_string)
        puts "Test File Selected: #{tests_string}"
        system_run command.gsub('<test>', tests_string)
      end

      def sync(added:, removed:)
      end

      private

      def system_run(command)
        system command
      end
    end
  end
end
