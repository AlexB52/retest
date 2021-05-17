$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "retest"
require "byebug"
require "minitest/autorun"

FakeFS = Struct.new(:files) do
  def exist?(value)
    files.include? value
  end
end