require 'listen'

require 'string/similarity'
require 'observer'

require "retest/version"
require "retest/runner"
require "retest/repository"
require "retest/matching_options"
require "retest/options"
require "retest/version_control"
require "retest/setup"
require "retest/command"
require "retest/file_system"
require "retest/program"
require "retest/prompt"
require "retest/sounds"
require "retest/watcher"

Listen.adapter_warn_behavior = :log

module Retest
  class Error < StandardError; end
  class FileNotFound < StandardError; end

  def self.listen(options, listener: Watcher::Default)
    listener.watch(dir: '.', extensions: options.extensions, polling: options.force_polling?) do |modified, added, removed|
      yield modified, added, removed
    end
  end
end
