module Retest
  class Command
    class Base
      def initialize(all: false, file_system: FileSystem, command: nil)
        @file_system = file_system
        @all = all
        @command = command
      end

      def to_s
        raise NotImplementedError
      end

      def format_batch(*files)
        raise NotImplementedError
      end

      private

      attr_reader :all, :file_system, :command
    end
  end
end
