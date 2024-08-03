module Retest
  class Program
    attr_accessor :runner, :repository, :command, :all_runner
    def initialize(runner: nil, repository: nil, command: nil)
      @runner = runner
      @repository = repository
      @command = command
      @all_runner = Retest::Runners.runner_for(
        Retest::Command.for_options(Retest::Options.new(["--all"]), quiet: true).to_s
      )
    end

    def run(modified, added, removed)
      repository.sync(added: added, removed: removed)
      runner.sync(added: added, removed: removed)
      system('clear 2>/dev/null') || system('cls 2>/dev/null')

      runner.run (modified + added).first, repository: repository
    end

    def run_all
      system('clear 2>/dev/null') || system('cls 2>/dev/null')

      all_runner.run
    end

    def diff(branch)
      raise "Git not installed" unless VersionControl::Git.installed?
      test_files = repository.find_tests VersionControl::Git.diff_files(branch)

      puts "Tests found:"
      test_files.each { |test_file| puts "  - #{test_file}" }

      puts "Running tests..."
      runner.run_all_tests command.format_batch(*test_files)
    end
  end
end
