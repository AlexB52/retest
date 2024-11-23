module Retest
  class Command
    class Hardcoded < Base
      def to_s
        @command
      end

      def format_batch(*files)
      end
    end
  end
end
