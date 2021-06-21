module Retest
  class Command
    class Rails
      attr_reader :all, :file_system

      def initialize(all:, file_system: FileSystem)
        @file_system = file_system
        @all = all
      end

      def command
        return "#{root_command} <test>" unless all
        root_command
      end

      def run_all(*files, runner:)
        runner.run files.join(' ')
      end

      private

      def root_command
        return 'bin/rails test' if file_system.exist? 'bin/rails'

        'bundle exec rails test'
      end
    end
  end
end
