module Retest
  class Command
    class Rails < Rspec

      private

      def default_command(all:)
        command = if file_system&.exist? 'bin/rails'
          'bin/rails test'
        else
          'bundle exec rails test'
        end

        all ? command : "#{command} <test>"
      end
    end
  end
end
