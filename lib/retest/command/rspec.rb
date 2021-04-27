module Retest
  class Command
    Rspec = Struct.new(:all, :bin_file) do
      def self.command(all:, bin_file: File.exist?('bin/rspec'))
        new(all, bin_file).command
      end

      def command
        return "#{root_command} <test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rspec' if bin_file

        'bundle exec rspec'
      end
    end
  end
end