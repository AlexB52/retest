module Retest
  class Command
    Rake = Struct.new(:all, :bin_file) do
      def self.command(all:, bin_file: File.exist?('bin/rake'))
        new(all, bin_file).command
      end

      def command
        return "#{root_command} TEST=<test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rake test' if bin_file

        'bundle exec rake test'
      end
    end
  end
end