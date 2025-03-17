$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "retest"
require "byebug"
require "minitest/autorun"
require "support/fixtures"

module Retest
  # Remove Watchexec when not installed
  if defined?(Watcher::Watchexec) && !Watcher::Watchexec.installed?
    Watcher.send(:remove_const, :Watchexec)
    Watcher::Watchexec = Watcher::Default
  end
end
