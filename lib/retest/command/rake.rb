module Retest
  class Command
    Rake = Struct.new(:all, :file_system) do
      def self.command(all:, file_system: FileSystem)
        new(all, file_system).command
      end

      def command
        return "#{root_command} TEST=<test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rake test' if file_system.exist? 'bin/rake'

        'bundle exec rake test'
      end
    end
  end
end