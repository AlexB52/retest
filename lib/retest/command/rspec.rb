module Retest
  class Command
    Rspec = Struct.new(:all, :file_system) do
      def self.command(all:, file_system: FileSystem)
        new(all, file_system).command
      end

      def command
        return "#{root_command} <test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rspec' if file_system.exist? 'bin/rspec'

        'bundle exec rspec'
      end
    end
  end
end