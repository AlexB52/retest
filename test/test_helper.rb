$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "retest"
require "byebug"
require "minitest/autorun"

WAITING_TIME = 0.0001

def wait(time = WAITING_TIME)
  sleep time
end

FakeFS = Struct.new(:files) do
  def exist?(value)
    files.include? value
  end
end

class RaisingRunner
  class MethodCallError < StandardError; end

  def initialize
  end

  def sync(added:, removed:)
  end

  def run(file, repository:)
    raise MethodCallError, "#{__method__} should not be called"
  end
end

def wait_until(max_attempts: 10)
  attempts = 0
  begin
    yield
  rescue Minitest::Assertion => e
    raise e if attempts >= max_attempts
    wait
    attempts += 1
  end
end

