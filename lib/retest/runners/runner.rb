module Retest
  module Runners
    class Runner
      include Observable

      attr_accessor :command, :stdout, :command_stdin
      def initialize(command, stdout: $stdout, command_stdin: $stdin)
        @stdout  = stdout
        @command = command
        @command_stdin = command_stdin
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

      def running?
        @running
      end

      private

      def system_run(command)
        puts "running is true"
        @running = true
        result = system(command, in: @command_stdin, out: @stdout) ? :tests_pass : :tests_fail
        changed
        notify_observers(result)
        puts "running is false"
        @running = false
      end

      def log(message)
        stdout.puts(message)
      end
    end
  end
end
