module Retest
  class Command
    class Rspec < Base
      def to_s
        return "#{root_command} <test>" unless all
        root_command
      end

      def format_batch(*files)
        files.join(' ')
      end

      private

      def root_command
        return 'bin/rspec' if file_system.exist? 'bin/rspec'

        'bundle exec rspec'
      end
    end
  end
end