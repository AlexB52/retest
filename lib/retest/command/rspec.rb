module Retest
  class Command
    class Rspec < Base
      def to_s
        if all
          root_command
        else
          "#{root_command} <test>"
        end
      end

      def format_batch(*files)
        files.join(' ')
      end

      private

      def root_command
        if file_system.exist? 'bin/rspec'
          'bin/rspec'
        else
          'bundle exec rspec'
        end
      end
    end
  end
end