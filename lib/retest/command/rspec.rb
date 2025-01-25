module Retest
  class Command
    class Rspec < Base
      def format_batch(*files)
        files.join(' ')
      end

      private

      def all_command
        return command if all

        command.gsub('<test>', '').strip
      end

      def one_command
        return command unless all

        "#{command} <test>"
      end

      def default_command(all:)
        command = if file_system&.exist? 'bin/rspec'
          'bin/rspec'
        else
          'bundle exec rspec'
        end

        all ? command : "#{command} <test>"
      end
    end
  end
end