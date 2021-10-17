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

      def sync(added:, removed:)
      end

      def matching?
        false
      end

      def unmatching?
        !matching?
      end
    end
  end
end
