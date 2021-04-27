module Retest
  class Command
    Ruby = Struct.new(:all, :bin_file) do
      def self.command(all: false, bin_file: false)
        new(false, false).command
      end

      def command
        'bundle exec ruby <test>'
      end
    end
  end
end