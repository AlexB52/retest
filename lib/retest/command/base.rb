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
        all ? all_command : batched_command
      end

      def eql?(other)
        hash == other.hash
      end
      alias == eql?

      def hash
        [self.class, file_system, command].hash
      end

      def switch_to(type)
        case type.to_s
        when 'all'     then clone(command: all_command)
        when 'batched' then clone(command: batched_command)
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
        raise_multiple_test_not_supported
      end

      private

      def all
        !has_test?
      end

      def batched_command
        raise NotImplementedError, 'must define a BATCHED command'
      end

      def all_command
        raise NotImplementedError, 'must define a ALL command'
      end

      def default_command(all: false)
        raise NotImplementedError, 'must define a DEFAULT command'
      end

      def clone(params = {})
        self.class.new(**{ all: all, file_system: file_system, command: command }.merge(params))
      end

      def raise_multiple_test_not_supported
        raise MultipleTestsNotSupported, "Multiple test files run not supported for command: '#{to_s}'"
      end
    end
  end
end
