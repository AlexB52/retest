module Retest
  class Program
    attr_accessor :runner, :repository, :command, :extension
    def initialize(runner: nil, repository: nil, command: nil, extension: /\.rb$/)
      @runner = runner
      @repository = repository
      @command = command
      @extension = extension
    end

    def start
      puts "Launching Retest..."
      build.start
      puts "Ready to refactor! You can make file changes now"
    end

    def diff(branch)
      raise "Git not installed" unless VersionControl::Git.installed?
      test_files = repository.find_tests VersionControl::Git.diff_files(branch)

      puts "Tests found:"
      test_files.each { |test_file| puts "  - #{test_file}" }

      puts "Running tests..."
      command.run_all *test_files, runner: runner
    end

    private

    def build
      Listen.to('.', only: extension, relative: true) do |modified, added, removed|
        begin
          repository.sync(added: added, removed: removed)
          runner.sync(added: added, removed: removed)
          system('clear 2>/dev/null') || system('cls 2>/dev/null')

          runner.run (modified + added).first, repository: repository
        rescue => e
          puts "Something went wrong: #{e.message}"
        end
      end
    end
  end
end
