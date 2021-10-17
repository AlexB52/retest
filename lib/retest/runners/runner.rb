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
        system command
      end

      def run_all_tests(tests_string)
        puts "Test File Selected: #{tests_string}"
        system command.gsub('<test>', tests_string)
      end

      def sync(added:, removed:)
      end
    end
  end
end
