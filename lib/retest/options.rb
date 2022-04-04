require 'tty-option'

module Retest
  class Options
    include TTY::Option

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

      example <<~EOS
      Let retest identify which command to run
        $ retest
        $ retest --auto
      EOS

      example <<~EOS
      Let retest identify which command to run for all tests
        $ retest --all
        $ retest --auto --all
      EOS

      example <<~EOS
      Run a sanity check on changed files from a branch
        $ retest --diff origin/main --rails
        $ retest --diff main --auto
      EOS
    end

    argument :command do
      optional
      desc <<~EOS
      The test command to rerun when a file changes.
      Use <test> placeholder to tell retest where to put the matching spec.
      EOS
    end

    option :diff do
      desc "Pipes all matching tests from diffed branch to test command"
      long "--diff=git-branch"
    end

    option :ext do
      desc "Regex of file extensions to listen to"
      long "--ext=regex"
      default "\\.rb$"
    end

    flag :all do
      long "--all"
      desc "Run all the specs of a specificied ruby setup"
    end

    flag :auto do
      long "--auto"
      desc "Indentify repository setup and runs appropriate command"
    end

    flag :notify do
      long "--notify"
      desc "Play a sound when specs pass or fail (macOS only)"
    end

    flag :help do
      short "-h"
      long "--help"
      desc "Print usage"
    end

    flag :rspec do
      long "--rspec"
      desc "Shortcut for a standard RSpec setup"
    end

    flag :rake do
      long "--rake"
      desc "Shortcut for a standard Rake setup"
    end

    flag :rails do
      long "--rails"
      desc "Shortcut for a standard Rails setup"
    end

    flag :ruby do
      long "--ruby"
      desc "Shortcut for a Ruby project"
    end

    attr_reader :args

    def self.command(args)
      new(args).command
    end

    def initialize(args = [])
      self.args = args
    end

    def args=(args)
      @args = args
      parse args
    end

    def help?
      params[:help]
    end

    def full_suite?
      params[:all]
    end

    def auto?
      return true if no_options_passed?
      params[:auto]
    end

    def notify?
      params[:notify]
    end

    def extension
      Regexp.new(params[:ext])
    end

    private

    def no_options_passed?
      params.to_h.values.compact.uniq == ["\\.rb$", false]
    end
  end
end