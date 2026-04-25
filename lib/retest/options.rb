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

    attr_reader :args, :params

    def self.command(args)
      new(args).command
    end

    def initialize(args = [])
      self.args = args
    end

    def args=(args)
      @args = args.dup
      @params = DEFAULT_PARAMS.transform_values(&:dup)
      parse(@args)
    end

    def help
      parser.to_s
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
      remaining = args.dup
      parser.order!(remaining)
      params[:command] = remaining.shift
      raise OptionParser::InvalidArgument, remaining.join(' ') unless remaining.empty?
    end

    def parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: retest [options] [COMMAND]'
        opts.separator <<~ARGUMENTS

          Watch files and rerun matching tests when they change.

          Arguments:
              COMMAND                          Command to rerun when a file changes.
                                               Use <test> for the matching test file and
                                               <changed> for the changed file.

        ARGUMENTS
        opts.separator 'Options:'
        opts.on('--all',                                         'Run the full test suite for the selected setup')        { params[:all] = true }
        opts.on('--diff BRANCH',                                 'Run tests matching files changed from BRANCH')          { |value| params[:diff] = value }
        opts.on('--exts EXTENSIONS',                             'Comma-separated file extensions to watch (default: rb)'){ |value| params[:exts] = parse_extensions(value) }
        opts.on('-h', '--help',                                  'Show this help')                                        { params[:help] = true }
        opts.on('--notify',                                      'Play a sound when tests pass or fail (macOS only)')     { params[:notify] = true }
        opts.on('--polling',                                     'Use polling for file watching')                         { params[:polling] = true } #Some filesystems won't work without it VM/Vagrant Shared folders, NFS, Samba, sshfs...
        opts.on('--rails',                                       'Use the standard Rails test command')                   { params[:rails] = true }
        opts.on('--rake',                                        'Use the standard Rake test command')                    { params[:rake] = true }
        opts.on('--rspec',                                       'Use the standard RSpec test command')                   { params[:rspec] = true }
        opts.on('--ruby',                                        'Use the standard Ruby test command')                    { params[:ruby] = true }
        opts.on('-v', '--version',                               'Show retest version')                                   { params[:version] = true }
        opts.on('-w', '--watcher WATCHER', %w[listen watchexec], 'File watcher to use (listen or watchexec)')             { |value| params[:watcher] = value.to_sym }

        opts.separator <<~EXAMPLES

          Examples:
              $ retest
                  Auto-detect the project setup and rerun matching tests

              $ retest --all
                  Auto-detect the project setup and run the full suite

              $ retest --rails
                  Use the standard Rails test command

              $ retest 'bin/rails test <test>'
                  Rerun the matching Rails test file

              $ retest 'rubocop <changed> && bin/rails test <test>'
                  Run a check on the changed file, then run the matching test

              $ retest --diff main
                  Run tests matching files changed from main
        EXAMPLES
      end
    end

    def parse_extensions(value)
      value.split(',').map(&:strip).reject(&:empty?)
    end
  end
end
