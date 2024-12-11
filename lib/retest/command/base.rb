module Retest
  class Command
    class MultipleTestsNotSupported < StandardError; end

    class Base
      def initialize(all: false, file_system: FileSystem, command: nil)
        @file_system = file_system
        @all = all
        @command = command
      end

      def clone(params = {})
        self.class.new(**{ all: all, file_system: file_system, command: command }.merge(params))
      end

      def has_changed?
        to_s.include?('<changed>')
      end

      def has_test?
        to_s.include?('<test>')
      end

      def to_s
        @command
      end

      def format_batch(*files)
        raise MultipleTestsNotSupported, "Multiple test files run not supported for '#{to_s}'"
      end

      private

      attr_reader :all, :file_system, :command
    end
  end
end
