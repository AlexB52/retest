module Retest
  class Command
    class Rake
      attr_reader :all, :file_system

      def initialize(all:, file_system: FileSystem)
        @file_system = file_system
        @all = all
      end

      def to_s
        return "#{root_command} TEST=<test>" unless all
        root_command
      end

      def format_batch(*files)
        files.size > 1 ? "\"{#{files.join(',')}}\"" : files.first
      end

      def run_all(*files, runner:)
        runner.run files.size > 1 ? "\"{#{files.join(',')}}\"" : files.first
      end

      private

      def root_command
        return 'bin/rake test' if file_system.exist? 'bin/rake'

        'bundle exec rake test'
      end
    end
  end
end
