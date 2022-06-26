module Retest
  module Runners
    class VariableRunner < Runner
      def cached_test_file
        @cached_test_file
      end

      def cached_test_file=(value)
        @cached_test_file = value || @cached_test_file
      end

      def run(changed_file, repository:)
        self.cached_test_file = repository.find_test(changed_file)

        return print_test_file_not_found unless cached_test_file

        log(<<~FILES)
          Files Selected:
            - changed: #{changed_file}
            - test: #{cached_test_file}

        FILES

        system_run command
          .gsub('<test>', cached_test_file)
          .gsub('<changed>', changed_file)
      end

      def sync(added:, removed:)
        remove(removed)
      end

      private

      def print_test_file_not_found
        log(<<~ERROR)
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        ERROR
      end

      def remove(purged)
        return if purged.empty?

        if purged.is_a? Array
          purge_cache if purged.include? cached_test_file
        elsif purged.is_a? String
          purge_cache if purged == cached_test_file
        end
      end

      def purge_cache
        @cached_test_file = nil
      end
    end
  end
end
