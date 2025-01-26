module Retest
  class Command
    class Hardcoded < Base
      private

      def all_command
        command
      end

      def batched_command
        command
      end

      def default_command(all: false)
      end
    end
  end
end
