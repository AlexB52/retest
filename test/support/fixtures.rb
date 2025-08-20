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

  class EmptyRunner
    attr_reader :journal
    def initialize
      @journal = []
    end

    def sync(*args, **kwargs)
      add_to_journal(__method__, args: args, kwargs: kwargs)
    end

    def run(*args, **kwargs)
      add_to_journal(__method__, args: args, kwargs: kwargs)
    end

    private

    def add_to_journal(method, args:, kwargs:)
      @journal << { method: method, args: args, kwargs: kwargs }
    end
  end

  class RaisingRunner < EmptyRunner
    def run(file, repository:)
      raise MethodCallError, "#{__method__} should not be called"
    end
  end
end
