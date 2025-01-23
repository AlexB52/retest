module Retest
  class Command
    class Ruby < Base
      def to_s
        if file_system.exist? 'Gemfile.lock'
          'bundle exec ruby <test>'
        else
          'ruby <test>'
        end
      end

      def format_batch(*files)
        files.size > 1 ? %Q{-e "#{files.map { |file| "require './#{file}';" }.join}"} : files.first
      end

      def switch_to(type)
        if type.to_s == 'all'
          raise AllTestsNotSupported, "All tests run not supported for '#{to_s}'"
        end

        super
      end
    end
  end
end