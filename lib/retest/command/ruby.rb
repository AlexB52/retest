module Retest
  class Command
    Ruby = Struct.new(:all, :file_system) do
      def self.command(all: false, file_system: FileSystem)
        new(false, file_system).command
      end

      def command
        if file_system.exist? 'Gemfile.lock'
          'bundle exec ruby <test>'
        else
          'ruby <test>'
        end
      end
    end
  end
end