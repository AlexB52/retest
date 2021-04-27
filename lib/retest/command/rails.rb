module Retest
  class Command
    Rails = Struct.new(:all, :bin_file) do
      def self.command(all:, bin_file: File.exist?('bin/rails'))
        new(all, bin_file).command
      end

      def command
        return "#{root_command} <test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rails test' if bin_file

        'bundle exec rails test'
      end
    end
  end
end