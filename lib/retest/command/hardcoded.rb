module Retest
  class Command
    class Hardcoded < Base
      private

      def all
        false
      end

      def all_command
        raise AllTestsNotSupported, "All tests run not supported for hardcoded command: '#{to_s}'"
      end

      def one_command
        command
      end

      def default_command(all: false)
      end
    end
  end
end
