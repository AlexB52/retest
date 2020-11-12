$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "retest"
require "byebug"
require "minitest/autorun"

Retest.configure do |config|
  config.logger = StringIO.new
end
