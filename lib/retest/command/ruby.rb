module Retest
  class Command
    Ruby = Struct.new(:all, :file_system) do
      def self.command(all: false, file_system: FileSystem)
        new(false, file_system).command
      end

      def command
        'bundle exec ruby <test>'
      end
    end
  end
end