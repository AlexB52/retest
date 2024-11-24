module Retest
  class Command
    class Base
      def initialize(all: false, file_system: FileSystem, command: nil)
        @file_system = file_system
        @all = all
        @command = command
      end

      def changed_type?
        to_s.include?('<changed>')
      end

      def test_type?
        to_s.include?('<test>')
      end

      def variable_type?
        test_type? && changed_type?
      end

      def hardcoded_type?
        !test_type? && !changed_type?
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
