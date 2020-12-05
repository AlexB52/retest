require 'tty-option'

module Retest
  class Options
    include TTY::Option

    RSPEC_COMMAND = "bundle exec rspec <test>"
    RAILS_COMMAND = "bundle exec rails test <test>"
    RAKE_COMMAND  = "bundle exec rake test TEST=<test>"
    RUBY_COMMAND  = "bundle exec ruby <test>"
    NO_COMMAND    = "echo You have no command assigned"

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

    def initialize(args = [])
      self.args = args
    end

    def command
      if params[:rspec]
        params[:all] ? ALL_RSPEC_COMMAND : RSPEC_COMMAND
      elsif params[:rake]
        params[:all] ? ALL_RAKE_COMMAND : RAKE_COMMAND
      elsif params[:rails]
        params[:all] ? ALL_RAILS_COMMAND : RAILS_COMMAND
      elsif params[:ruby]
        params[:all] ? NO_COMMAND : RUBY_COMMAND
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