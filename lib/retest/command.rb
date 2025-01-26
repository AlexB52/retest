require_relative 'command/base'
require_relative 'command/hardcoded'
require_relative 'command/rails'
require_relative 'command/rake'
require_relative 'command/rspec'
require_relative 'command/ruby'

module Retest
  class Command
    extend Forwardable

    def self.for_options(options)
      new(options: options).command
    end

    def_delegators :options, :params, :full_suite?, :auto?

    attr_accessor :options, :setup, :setup_identified
    def initialize(options: Options.new, setup: Setup.new)
      @options = options
      @setup = setup
      @setup_identified = nil
    end

    def command
      options_command || setup_command
    end

    private

    def options_command
      if    params[:command] then hardcoded_command(params[:command])
      elsif params[:rspec]   then rspec_command
      elsif params[:rails]   then rails_command
      elsif params[:ruby]    then ruby_command
      elsif params[:rake]    then rake_command
      end
    end

    def setup_command
      case setup.type
      when :rake  then rake_command
      when :rspec then rspec_command
      when :rails then rails_command
      when :ruby  then ruby_command
      else             ruby_command
      end
    end

    def hardcoded_command(command)
      Hardcoded.new(command: command)
    end

    def rspec_command
      Rspec.new(all: full_suite?)
    end

    def rails_command
      Rails.new(all: full_suite?)
    end

    def rake_command
      Rake.new(all: full_suite?)
    end

    def ruby_command
      Ruby.new(all: full_suite?)
    end
  end
end