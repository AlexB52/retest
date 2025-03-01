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
        $ retest 'bin/rails test <test>'
        $ retest --rails
      EOS

      example <<~EOS
      Runs rubocop and matching rails test after a file change
        $ retest 'rubocop <changed> && bin/rails test <test>'
      EOS

      example <<~EOS
      Runs all rails tests after a file change
        $ retest 'bin/rails test'
        $ retest --rails --all
      EOS

      example <<~EOS
      Runs a hardcoded command after a file change
        $ retest 'ruby lib/bottles_test.rb'
      EOS

      example <<~EOS
      Let retest identify which command to run
        $ retest
      EOS

      example <<~EOS
      Let retest identify which command to run for all tests
        $ retest --all
      EOS

      example <<~EOS
      Run a sanity check on changed files from a branch
        $ retest --diff main
        $ retest --diff origin/main --rails
      EOS
    end

    argument :command do
      optional
      desc <<~EOS
      The test command to rerun when a file changes.
      Use <test> or <changed> placeholders to tell retest where to reference the matching spec or the changed file in the command.
      EOS
    end

    option :diff do
      desc "Pipes all matching tests from diffed branch to test command"
      long "--diff=git-branch"
    end

    option :exts do
      desc "Comma separated of filenames extensions to filter to"
      long "--exts=<EXTENSIONS>"
      default "rb"
      convert :list
    end

    option :watcher do
      desc "Tool used to watch file events"
      permit %i[listen watchexec]
      long "--watcher=<WATCHER>"
      short "-w"
      convert :sym
    end

    flag :all do
      long "--all"
      desc "Run all the specs of a specificied ruby setup"
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

    flag :version do
      short "-v"
      long "--version"
      desc "Print retest version"
    end

    option :polling do
      long '--polling'
      desc <<~DESC.strip
        Use polling method when listening to file changes
        Some filesystems won't work without it
        VM/Vagrant Shared folders, NFS, Samba, sshfs...
      DESC
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

    def version?
      params[:version]
    end

    def full_suite?
      params[:all]
    end

    def notify?
      params[:notify]
    end

    def force_polling?
      params[:polling]
    end

    def extensions
      params[:exts]
    end

    def watcher
      params[:watcher] || :installed
    end

    def merge(options = [])
      self.class.new(@args.dup.concat(options))
    end
  end
end