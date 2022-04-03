module Retest
  module Runners
    class ChangeRunner < Runner
      def run(changed_file = nil, repository: nil)
        if changed_file
          puts "Changed File Selected: #{changed_file}"
          system_run command.gsub('<changed>', changed_file)
        else
          puts <<~ERROR
            404 - Test File Not Found
            Retest could not find a changed file to run.
          ERROR
        end
      end
    end
  end
end