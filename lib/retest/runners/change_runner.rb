module Retest
  module Runners
    class ChangeRunner < Runner
      def run(changed_files: [], test_files: [], repository: nil)
        changed_file = changed_files
        changed_file = changed_files.first if changed_files.is_a?(Array)

        return print_file_not_found unless changed_file

        log("Changed File Selected: #{changed_file}")
        system_run command.to_s.gsub('<changed>', changed_file)
      end

      private

      def print_file_not_found
        log(<<~ERROR)
          404 - File Not Found
          Retest could not find a changed file to run.
        ERROR
      end
    end
  end
end