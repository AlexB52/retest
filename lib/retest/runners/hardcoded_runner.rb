module Retest
  module Runners
    class HardcodedRunner < Runner
      def run(_ = nil)
        system command
      end
    end
  end
end
