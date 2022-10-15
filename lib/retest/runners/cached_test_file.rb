module Retest
  module Runners
    module CachedTestFile
      def cached_test_file
        @cached_test_file
      end

      def cached_test_file=(value)
        @cached_test_file = value || @cached_test_file
      end

      def purge_test_file(purged)
        return if purged.empty?

        if purged.is_a?(Array) && purged.include?(cached_test_file)
          @cached_test_file = nil
        elsif purged.is_a?(String) && purged == cached_test_file
          @cached_test_file = nil
        end
      end
    end
  end
end
