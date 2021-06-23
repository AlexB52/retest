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

    def self.for_setup(setup)
      new(setup: setup).command
    end

    def_delegator :setup, :type
    def_delegators :options, :params, :full_suite?, :auto?

    attr_accessor :options, :setup
    def initialize(options: Options.new, setup: Setup.new, output_stream: STDOUT)
      @options = options
      @setup = setup
      @output_stream = output_stream
    end

    def command
      return default_command if auto?
      options_command || default_command
    end

    def options_command
      return params[:command] if params[:command]

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
      @output_stream.puts "Setup identified: [#{type.upcase}]. Using command: '#{setup_command}'"
      setup_command
    end

    private

    def rspec_command
      Rspec.new(all: full_suite?).command
    end

    def rails_command
      Rails.new(all: full_suite?).command
    end

    def rake_command
      Rake.new(all: full_suite?).command
    end

    def ruby_command
      Ruby.new(all: full_suite?).command
    end
  end
end