module Retest
  module Runners
    class ChangeRunner < Runner
      def run(changed_file = nil)
        if changed_file
          puts "Test File Selected: #{changed_file}"
          system command.gsub('<changed>', changed_file)
        else
          puts <<~ERROR
            404 - Test File Not Found
            Retest could not find a changed file to run.
          ERROR
        end
      end

      def matching?
        true
      end
    end
  end
end