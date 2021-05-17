module Retest
  class Command
    module Ruby
      module_function

      def command(all: false, file_system: FileSystem)
        if file_system.exist? 'Gemfile.lock'
          'bundle exec ruby <test>'
        else
          'ruby <test>'
        end
      end
    end
  end
end