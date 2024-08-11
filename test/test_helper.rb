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

class BlockingInput
  def initialize
    @io = StringIO.new
  end

  def puts(value)
    @io = StringIO.new(value)
  end

  def gets
    loop do
      wait
      line = @io.gets.to_s
      break line unless line.empty?
    end
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

