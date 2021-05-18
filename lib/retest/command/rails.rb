module Retest
  class Command
    Rails = Struct.new(:all, :file_system) do
      def self.command(all:, file_system: FileSystem)
        new(all, file_system).command
      end

      def command
        return "#{root_command} <test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rails test' if file_system.exist? 'bin/rails'

        'bundle exec rails test'
      end
    end
  end
end