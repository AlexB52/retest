require_relative 'command/base'
require_relative 'command/hardcoded'
require_relative 'command/rails'
require_relative 'command/rake'
require_relative 'command/rspec'
require_relative 'command/ruby'

module Retest
  class Command
    extend Forwardable

    def self.for_options(options, stdout: $stdout)
      new(options: options, stdout: stdout).command
    end

    def_delegator :setup, :type
    def_delegators :options, :params, :full_suite?, :auto?

    attr_accessor :options, :setup
    def initialize(options: Options.new, setup: Setup.new, stdout: $stdout)
      @options = options
      @setup = setup
      @stdout = stdout
    end

    def command
      options_command || default_command
    end

    def options_command
      if params[:command]
        return hardcoded_command(params[:command])
      end

      if    params[:rspec] then rspec_command
      elsif params[:rails] then rails_command
      elsif params[:ruby]  then ruby_command
      elsif params[:rake]  then rake_command
      else
      end
    end

    def setup_command
      case type
      when :rake  then rake_command
      when :rspec then rspec_command
      when :rails then rails_command
      when :ruby  then ruby_command
      else             ruby_command
      end
    end

    def default_command
      log "Setup identified: [#{type.upcase}]. Using command: '#{setup_command}'"
      setup_command
    end

    private

    def log(message)
      @stdout&.puts(message)
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