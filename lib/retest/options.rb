require 'optparse'

module Retest
  class Options
    DEFAULT_PARAMS = {
      all: false,
      diff: nil,
      exts: %w[rb],
      help: false,
      notify: false,
      polling: false,
      rake: false,
      rails: false,
      rspec: false,
      ruby: false,
      version: false,
      watcher: nil,
      command: nil
    }.freeze

    HELP = <<~TEXT
      Usage: retest  [OPTIONS] [COMMAND]

      Watch a file change and run it matching spec.

      Arguments:
        COMMAND  The test command to rerun when a file changes.
                 Use <test> or <changed> placeholders to tell retest where to
                 reference the matching spec or the changed file in the command.
                 

      Options:
            --all                Run all the specs of a specificied ruby setup
            --diff=git-branch    Pipes all matching tests from diffed branch to test
                                 command
            --exts=<EXTENSIONS>  Comma separated of filenames extensions to filter
                                 to (default "rb")
        -h, --help               Print usage
            --notify             Play a sound when specs pass or fail (macOS only)
            --polling            Use polling method when listening to file changes
                                 Some filesystems won't work without it
                                 VM/Vagrant Shared folders, NFS, Samba, sshfs...
            --rails              Shortcut for a standard Rails setup
            --rake               Shortcut for a standard Rake setup
            --rspec              Shortcut for a standard RSpec setup
            --ruby               Shortcut for a Ruby project
        -v, --version            Print retest version
        -w, --watcher=<WATCHER>  Tool used to watch file events (permitted: listen,
                                 watchexec)

      Examples:
        Runs a matching rails test after a file change
          $ retest 'bin/rails test <test>'
          $ retest --rails

        Runs rubocop and matching rails test after a file change
          $ retest 'rubocop <changed> && bin/rails test <test>'

        Runs all rails tests after a file change
          $ retest 'bin/rails test'
          $ retest --rails --all

        Runs a hardcoded command after a file change
          $ retest 'ruby lib/bottles_test.rb'

        Let retest identify which command to run
          $ retest

        Let retest identify which command to run for all tests
          $ retest --all

        Run a sanity check on changed files from a branch
          $ retest --diff main
          $ retest --diff origin/main --rails
    TEXT

    attr_reader :args, :params

    def self.command(args)
      new(args).command
    end

    def initialize(args = [])
      self.args = args
    end

    def args=(args)
      @args = args.dup
      @params = DEFAULT_PARAMS.transform_values do |value|
        value.is_a?(Array) ? value.dup : value
      end
      parse(@args)
    end

    def help
      HELP
    end

    def command
      params[:command]
    end

    def auto?
      command.nil?
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

    private

    def parse(args)
      parser = build_parser
      tokens = normalize_args(args)
      index = 0

      while index < tokens.length
        token = tokens[index]

        if flag_token?(token)
          consumed = parse_option(parser, tokens, index)
          index += consumed
          next
        end

        params[:command] ||= token
        index += 1
      end
    end

    def build_parser
      OptionParser.new do |opts|
        opts.on('--diff=git-branch', '--diff git-branch') { |value| params[:diff] = value }
        opts.on('--exts=<EXTENSIONS>', '--exts EXTENSIONS') { |value| params[:exts] = parse_extensions(value) }
        opts.on('-w', '--watcher=<WATCHER>', '--watcher WATCHER') { |value| params[:watcher] = parse_watcher(value) }
        opts.on('--all') { params[:all] = true }
        opts.on('--notify') { params[:notify] = true }
        opts.on('-h', '--help') { params[:help] = true }
        opts.on('-v', '--version') { params[:version] = true }
        opts.on('--polling') { params[:polling] = true }
        opts.on('--rspec') { params[:rspec] = true }
        opts.on('--rake') { params[:rake] = true }
        opts.on('--rails') { params[:rails] = true }
        opts.on('--ruby') { params[:ruby] = true }
      end
    end

    def normalize_args(args)
      args.flat_map do |arg|
        next arg unless arg.start_with?('--')

        parts = arg.split(/\s+/, 2)
        parts.length == 2 ? parts : arg
      end
    end

    def flag_token?(token)
      token.start_with?('-')
    end

    def parse_option(parser, tokens, index)
      token = tokens[index]
      buffer = [token]

      if option_argument_required?(token) && tokens[index + 1]
        buffer << tokens[index + 1]
      end

      begin
        parser.parse(buffer.dup)
        buffer.length
      rescue OptionParser::ParseError
        1
      end
    end

    def option_argument_required?(token)
      return false if token.include?('=')

      token == '--diff' || token == '--exts' || token == '--watcher' || token == '-w'
    end

    def parse_extensions(value)
      value.split(',').map(&:strip).reject(&:empty?)
    end

    def parse_watcher(value)
      watcher = value.to_sym
      %i[listen watchexec].include?(watcher) ? watcher : nil
    end
  end
end
