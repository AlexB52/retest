module Retest
  module Runners
    class Runner
      include Observable

      attr_accessor :command, :output
      def initialize(command, output: nil)
        @output = output || STDOUT
        @command = command
      end

      def ==(obj)
        command == obj.command && obj.class == self.class
      end

      def run(changed_file = nil, repository: nil)
        system_run command
      end

      def run_all_tests(tests_string)
        log("Test File Selected: #{tests_string}")
        system_run command.gsub('<test>', tests_string)
      end

      def sync(added:, removed:)
      end

      private

      def system_run(command)
        result = system(command) ? :tests_pass : :tests_fail
        changed
        notify_observers(result)
      end

      def log(out)
        output.puts(out)
      end
    end
  end
end
