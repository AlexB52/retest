$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "retest"
require "byebug"
require "minitest/autorun"

class TestLogger < SimpleDelegator
  def clear
    truncate(0)
    rewind
  end
end

Retest.configure do |config|
  config.logger = TestLogger.new StringIO.new
end
