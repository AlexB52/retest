module Retest
  module Runners
    class Runner
      include Observable

      attr_accessor :command, :stdout
      def initialize(command, stdout: $stdout)
        @stdout  = stdout
        @command = command
      end

      def ==(obj)
        command == obj.command && obj.class == self.class
      end

      def run(changed_file = nil, repository: nil)
        system_run command
      end

      def run_all_tests(tests_string)
        raise NotSupportedError, 'cannot run multiple test files against this command'
      end

      def sync(added:, removed:)
      end

      private

      def system_run(command)
        result = system(command) ? :tests_pass : :tests_fail
        changed
        notify_observers(result)
      end

      def log(message)
        stdout.puts(message)
      end
    end
  end
end
