module Retest
  class Command
    class Rspec
      attr_reader :all, :file_system

      def initialize(all:, file_system: FileSystem)
        @file_system = file_system
        @all = all
      end

      def to_s
        return "#{root_command} <test>" unless all
        root_command
      end

      def format_batch(*files)
        files.join(' ')
      end

      def run_all(*files, runner:)
        runner.run files.join(' ')
      end

      private

      def root_command
        return 'bin/rspec' if file_system.exist? 'bin/rspec'

        'bundle exec rspec'
      end
    end
  end
end