require_relative "cached_test_file"

module Retest
  module Runners
    class VariableRunner < Runner
      include CachedTestFile

      def run(changed_files: [], test_files: [], repository:)
        changed_file = changed_files.is_a?(Array) ? changed_files.first : changed_files

        self.cached_test_file = repository.find_test(changed_file)

        return print_file_not_found unless cached_test_file

        log(<<~FILES)
          Files Selected:
            - changed: #{changed_file}
            - test: #{cached_test_file}

        FILES

        system_run command.to_s
          .gsub('<test>', cached_test_file)
          .gsub('<changed>', changed_file)
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
