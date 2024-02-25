require 'listen'

require 'string/similarity'
require 'observer'

require "retest/version"
require "retest/runners"
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

Listen.adapter_warn_behavior = :log

module Retest
  class Error < StandardError; end

  def self.listen(options, listener: Listen)
    listener.to('.', only: options.extension, relative: true, force_polling: options.force_polling?) do |modified, added, removed|
      yield modified, added, removed
    end.start
  end
end
