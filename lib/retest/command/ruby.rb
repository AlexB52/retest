module Retest
  class Command
    class Ruby < Base
      def format_batch(*files)
        files.size > 1 ? %Q{-e "#{files.map { |file| "require './#{file}';" }.join}"} : files.first
      end

      private

      def default_command(all: false)
        if file_system&.exist? 'Gemfile.lock'
          'bundle exec ruby <test>'
        else
          'ruby <test>'
        end
      end

      def all_command
        raise AllTestsNotSupported, "All tests run not supported for Ruby command: '#{to_s}'"
      end

      def batched_command
        command
      end
    end
  end
end