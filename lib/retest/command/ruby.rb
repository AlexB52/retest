module Retest
  class Command
    class Ruby
      attr_reader :all, :file_system

      def initialize(all:, file_system: FileSystem)
        @file_system = file_system
        @all = all
      end

      def run_all(*files, runner:)
        files.each { |file| runner.run file }
      end

      def to_s
        if file_system.exist? 'Gemfile.lock'
          'bundle exec ruby <test>'
        else
          'ruby <test>'
        end
      end
    end
  end
end