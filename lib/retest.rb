require "retest/version"
require "retest/command"
require "retest/repository"
require "retest/test_options"
require "retest/listen_options"
require 'string/similarity'

module Retest
  class Error < StandardError; end

  def self.build(command:)
    Listen.to('.', Retest::ListenOptions.to_h) do |modified, added, removed|
      if modified.any?
        system("clear") || system("cls")
        command.run(modified.first.strip)
      end
    rescue => e
      puts "Something went wrong: #{e.message}"
    end
  end
end
