require 'listen'
require "retest/version"
require "retest/command"
require "retest/repository"
require "retest/test_options"
require "retest/listen_options"
require "retest/concerns/configurable"
require 'string/similarity'

module Retest
  include Configurable
  class Error < StandardError; end

  def self.build(command:, clear_window: true)
    Listen.to('.', ListenOptions.to_h) do |modified, added, removed|
      begin
        if modified.any?
          system("clear") || system("cls") if clear_window
          command.run(modified.first.strip)
        end
      rescue => e
        puts "Something went wrong: #{e.message}"
      end
    end
  end
end
