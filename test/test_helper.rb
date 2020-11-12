$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "retest"
require "byebug"
require "minitest/autorun"

class TestLogger < SimpleDelegator
  def initialize
    __setobj__ StringIO.new
  end

  def clear
    truncate(0)
    rewind
  end
end
