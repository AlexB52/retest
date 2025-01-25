module Retest
  class Command
    class Rake < Base
      def format_batch(*files)
        files.size > 1 ? %Q{"{#{files.join(',')}}"} : files.first
      end

      private

      def default_command(all: false)
        command = if file_system&.exist? 'bin/rake'
          'bin/rake test'
        else
          'bundle exec rake test'
        end

        all ? command : "#{command} TEST=<test>"
      end

      def all_command
        return command if all

        command.gsub('TEST=<test>', '').strip
      end

      def one_command
        return command unless all

        "#{command} TEST=<test>"
      end
    end
  end
end
