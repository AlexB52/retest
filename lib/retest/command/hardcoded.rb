module Retest
  class Command
    class Hardcoded < Base
      def switch_to(type)
        if type.to_s == 'all'
          raise AllTestsNotSupported, "All tests run not supported for '#{to_s}'"
        end

        super
      end
    end
  end
end
