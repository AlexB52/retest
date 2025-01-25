module Retest
  class Command
    class MultipleTestsNotSupported < StandardError; end
    class AllTestsNotSupported < StandardError; end

    class Base
      attr_reader :file_system, :command

      def initialize(all: false, file_system: FileSystem, command: nil)
        @file_system = file_system
        @command = command || default_command(all: all)
      end

      def to_s
        all ? all_command : one_command
      end

      def eql?(other)
        hash == other.hash
      end
      alias == eql?

      def hash
        [file_system, command].hash
      end

      def switch_to(type)
        case type.to_s
        when 'all' then clone(command: all_command)
        when 'one' then clone(command: one_command)
        else raise ArgumentError, "unknown type to switch to: #{type}"
        end
      end

      def hardcoded?
        !has_changed? && !has_test?
      end

      def has_changed?
        command.include?('<changed>')
      end

      def has_test?
        command.include?('<test>')
      end

      def format_batch(*files)
        raise MultipleTestsNotSupported, "Multiple test files run not supported for '#{to_s}'"
      end

      private

      def all
        !has_test?
      end

      def one_command
        raise MultipleTestsNotSupported, "Multiple test files run not supported for '#{to_s}'"
      end

      def all_command
        raise AllTestsNotSupported, "All tests run not supported for hardcoded command: '#{to_s}'"
      end

      def default_command(all: false)
        raise NotImplementedError, 'must define a default command'
      end

      def clone(params = {})
        self.class.new(**{ all: all, file_system: file_system, command: command }.merge(params))
      end
    end
  end
end
