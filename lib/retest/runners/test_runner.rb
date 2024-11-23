require_relative "cached_test_file"

module Retest
  module Runners
    class TestRunner < Runner
      include CachedTestFile

      def run(changed_file, repository:)
        self.cached_test_file = repository.find_test(changed_file)

        return print_file_not_found unless cached_test_file

        log("Test File Selected: #{cached_test_file}")
        system_run command.gsub('<test>', cached_test_file)
      end

      def run_all_tests(tests_string)
        log("Test Files Selected: #{tests_string}")
        system_run command.gsub('<test>', tests_string)
      end

      def sync(added:, removed:)
        purge_test_file(removed)
      end

      private

      def print_file_not_found
        log(<<~ERROR)
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        ERROR
      end
    end
  end
end
