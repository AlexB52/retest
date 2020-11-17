require 'listen'
require 'string/similarity'

require "retest/version"
require "retest/command"
require "retest/repository"
require "retest/test_options"
require "retest/listen_options"

module Retest
  class Error < StandardError; end

  def self.build(command:)
    Listen.to('.', ListenOptions.to_h) do |modified, added, removed|
      begin
        if modified.any?
          `clear 2>&1` || `cls 2>&1`
          command.run(modified.first.strip)
        end
      rescue => e
        puts "Something went wrong: #{e.message}"
      end
    end
  end
end
