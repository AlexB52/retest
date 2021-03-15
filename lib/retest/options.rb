require 'tty-option'

module Retest
  class Options
    include TTY::Option

    RSPEC_COMMAND = "bundle exec rspec <test>"
    RAILS_COMMAND = "bundle exec rails test <test>"
    RAKE_COMMAND  = "bundle exec rake test TEST=<test>"
    RUBY_COMMAND  = "bundle exec ruby <test>"

    ALL_RAKE_COMMAND  = "bundle exec rake test"
    ALL_RAILS_COMMAND = "bundle exec rails test"
    ALL_RSPEC_COMMAND = "bundle exec rspec"

    usage do
      program "retest"

      command nil

      desc "Watch a file change and run it matching spec."

      example <<~EOS
      Runs a matching rails test after a file change
        $ retest 'bundle exec rails test <test>'
        $ retest --rails
      EOS

      example <<~EOS
      Runs all rails tests after a file change
        $ retest 'bundle exec rails test'
        $ retest --rails --all
      EOS

      example <<~EOS
      Runs a hardcoded command after a file change
        $ retest 'ruby lib/bottles_test.rb'
      EOS
    end

    argument :command do
      optional
      desc <<~EOS
      The test command to rerun when a file changes.
      Use <test> placeholder to tell retest where to put the matching spec.
      EOS
    end

    flag :all do
      long "--all"
      desc "Run all the specs of a specificied ruby setup"
    end

    flag :auto do
      long "--auto"
      desc "Indentify repository setup and runs appropriate command"
    end

    flag :help do
      short "-h"
      long "--help"
      desc "Print usage"
    end

    flag :rspec do
      long "--rspec"
      desc "Shortcut for '#{RSPEC_COMMAND}'"
    end

    flag :rake do
      long "--rake"
      desc "Shortcut for '#{RAKE_COMMAND}'"
    end

    flag :rails do
      long "--rails"
      desc "Shortcut for '#{RAILS_COMMAND}'"
    end

    flag :ruby do
      long "--ruby"
      desc "Shortcut for '#{RUBY_COMMAND}'"
    end

    attr_reader :args

    def self.command(args)
      new(args).command
    end

    def initialize(args = [], output_stream: STDOUT, setup: Setup)
      self.args = args
      @output_stream = output_stream
      @setup = setup
    end

    def command
      return params[:command] if params[:command]

      if    params[:rspec] then rspec_command
      elsif params[:rake]  then rake_command
      elsif params[:rails] then rails_command
      elsif params[:ruby]  then ruby_command
      elsif params[:auto]  then default_command
      else                      default_command
      end
    end

    def args=(args)
      @args = args
      parse args
    end

    def help?
      params[:help]
    end

    private

    def full_suite?
      params[:all]
    end

    def default_command
      choose_command @setup.type, command_for(@setup.type)
    end

    def command_for(type)
      case type
      when :rspec then rspec_command
      when :rails then rails_command
      when :rake  then rake_command
      when :ruby  then ruby_command
      else             ruby_command
      end
    end

    def choose_command(type, command)
      @output_stream.puts "Setup identified: [#{type.upcase}]. Using command: '#{command}'"
      command
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