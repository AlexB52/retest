module Retest
  class Command
    class Rake < Base
      def to_s
        return "#{root_command} TEST=<test>" unless all
        root_command
      end

      def format_batch(*files)
        files.size > 1 ? "\"{#{files.join(',')}}\"" : files.first
      end

      private

      def root_command
        return 'bin/rake test' if file_system.exist? 'bin/rake'

        'bundle exec rake test'
      end
    end
  end
end
