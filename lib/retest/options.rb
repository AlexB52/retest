require 'tty-option'

module Retest
  class Options
    include TTY::Option

    RSPEC_COMMAND = "bundle exec rspec <test>"
    RAILS_COMMAND = "bundle exec rails test <test>"
    RAKE_COMMAND  = "bundle exec rake test TEST=<test>"
    RUBY_COMMAND  = "bundle exec ruby <test>"
    NO_COMMAND    = "echo You have no command assigned"

    usage do
      program "retest"

      command nil

      desc "Watch a file change and run it matching spec"

      example <<~EOS
      Runs a matching rails test after a file change
        $ retest 'bundle exec rails test <test>'
        $ retest --rails
      EOS

      example <<~EOS
      Runs all rails tests after a file change
        $ retest 'bundle exec rails test'
      EOS

      example <<~EOS
      Runs a hardcoded command after a file change
        $ retest 'ruby lib/bottles_test.rb'
      EOS
    end

    argument :command do
      optional
      desc "The test command to rerun when a file changes"
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

    flag :help do
      short "-h"
      long "--help"
      desc "Print usage"
    end

    attr_reader :args

    def self.command(args)
      new(args).command
    end

    def initialize(args = [])
      self.args = args
    end

    def command
      if params[:rspec]
        RSPEC_COMMAND
      elsif params[:rake]
        RAKE_COMMAND
      elsif params[:rails]
        RAILS_COMMAND
      elsif params[:ruby]
        RUBY_COMMAND
      else
        params[:command] || NO_COMMAND
      end
    end

    def args=(args)
      @args = args
      parse args
    end

    def help?
      params[:help]
    end
  end
end