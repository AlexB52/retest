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

      def run(file = nil)
      end

      def update(added:, removed:)
      end

      def remove
      end

      def matching?
        false
      end

      def unmatching?
        !unmatching
      end
    end
  end
end
