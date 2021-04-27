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
      Rspec.command(all: full_suite?)
    end

    def rails_command
      Rails.command(all: full_suite?)
    end

    def rake_command
      Rake.command(all: full_suite?)
    end

    def ruby_command
      Ruby.command(all: full_suite?)
    end


    Ruby = Struct.new(:all, :bin_file) do
      def self.command(all: false, bin_file: false)
        new(false, false).command
      end

      def command
        'bundle exec ruby <test>'
      end
    end

    Rake = Struct.new(:all, :bin_file) do
      def self.command(all:, bin_file: File.exist?('bin/rake'))
        new(all, bin_file).command
      end

      def command
        return "#{root_command} TEST=<test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rake test' if bin_file

        'bundle exec rake test'
      end
    end

    Rspec = Struct.new(:all, :bin_file) do
      def self.command(all:, bin_file: File.exist?('bin/rspec'))
        new(all, bin_file).command
      end

      def command
        return "#{root_command} <test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rspec' if bin_file

        'bundle exec rspec'
      end
    end

    Rails = Struct.new(:all, :bin_file) do
      def self.command(all:, bin_file: File.exist?('bin/rails'))
        new(all, bin_file).command
      end

      def command
        return "#{root_command} <test>" unless all
        root_command
      end

      private

      def root_command
        return 'bin/rails test' if bin_file

        'bundle exec rails test'
      end
    end
  end
end