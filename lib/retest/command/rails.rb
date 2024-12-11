module Retest
  class Command
    class Rails < Base
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
        if file_system.exist? 'bin/rails'
          'bin/rails test'
        else
          'bundle exec rails test'
        end
      end
    end
  end
end
