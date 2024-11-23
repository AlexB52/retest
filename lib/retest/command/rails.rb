module Retest
  class Command
    class Rails < Base
      def to_s
        return "#{root_command} <test>" unless all
        root_command
      end

      def format_batch(*files)
        files.join(' ')
      end

      private

      def root_command
        return 'bin/rails test' if file_system.exist? 'bin/rails'

        'bundle exec rails test'
      end
    end
  end
end
