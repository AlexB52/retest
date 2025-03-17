module Retest
  class MethodCallError < StandardError; end

  FakeFS = Struct.new(:files) do
    def exist?(value)
      files.include? value
    end
  end

  class RaisingRepository
    def find_test(_)
      raise MethodCallError, "#{__method__} should not be called"
    end
  end

  class RaisingRunner
    def initialize
    end

    def sync(added:, removed:)
    end

    def run(file, repository:)
      raise MethodCallError, "#{__method__} should not be called"
    end
  end
end
