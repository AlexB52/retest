module Retest
  class Command
    class MultipleTestsNotSupported < StandardError; end
    class AllTestsNotSupported < StandardError; end

    class Base
      attr_reader :all, :file_system, :command

      def initialize(all: false, file_system: FileSystem, command: nil)
        @file_system = file_system
        @all = all
        @command = command
      end

      def eql?(other)
        hash == other.hash
      end
      alias == eql?

      def hash
        [all, file_system, command].hash
      end

      def switch_to(type)
        case type.to_s
        when 'all' then clone(all: true)
        when 'one' then clone(all: false)
        else raise ArgumentError, "unknown type to switch to: #{type}"
        end
      end

      def hardcoded?
        !has_changed? && !has_test?
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

      def clone(params = {})
        self.class.new(**{ all: all, file_system: file_system, command: command }.merge(params))
      end
    end
  end
end
