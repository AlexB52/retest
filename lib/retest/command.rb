module Retest
  class Command
    RSPEC_COMMAND     = 'bundle exec rspec <test>'
    RAILS_COMMAND     = 'bundle exec rails test <test>'
    RAKE_COMMAND      = 'bundle exec rake test TEST=<test>'
    RUBY_COMMAND      = 'bundle exec ruby <test>'
    ALL_RAKE_COMMAND  = 'bundle exec rake test'
    ALL_RAILS_COMMAND = 'bundle exec rails test'
    ALL_RSPEC_COMMAND = 'bundle exec rspec'

    def self.for_options(options)
      new(options: options).options_command
    end

    def self.for_setup(setup)
      new(setup: setup).setup_command
    end

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

    def params
      options.params
    end

    def type
      setup.type
    end

    def full_suite?
      options.full_suite?
    end

    def auto?
      options.auto?
    end

    def rspec_command
      full_suite? ? ALL_RSPEC_COMMAND : RSPEC_COMMAND
    end

    def rails_command
      full_suite? ? ALL_RAILS_COMMAND : RAILS_COMMAND
    end

    def rake_command
      full_suite? ? ALL_RAKE_COMMAND : RAKE_COMMAND
    end

    def ruby_command
      RUBY_COMMAND
    end
  end
end