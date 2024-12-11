module Retest
  class Command
    class Rake < Base
      def to_s
        if all
          root_command
        else
          "#{root_command} TEST=<test>"
        end
      end

      def format_batch(*files)
        files.size > 1 ? %Q{"{#{files.join(',')}}"} : files.first
      end

      private

      def root_command
        if file_system.exist? 'bin/rake'
          'bin/rake test'
        else
          'bundle exec rake test'
        end
      end
    end
  end
end
