module Retest
  class Command
    class Ruby < Base
      def format_batch(*files)
        %Q{-e "#{files.map { |file| "require './#{file}';" }.join}"}
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