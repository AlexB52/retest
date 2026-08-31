require 'test_helper'

module Retest
  class ProgramTest < Minitest::Test
    class ForceBatchTest < Minitest::Test
      def setup
        @repository = Repository.new(files: %w[
          test/retest/command/hardcoded_test.rb
          test/retest/command/rails_test.rb
          test/retest/command/rake_test.rb
          test/retest/command/rspec_test.rb
          test/retest/command/ruby_test.rb
          test/retest/command_test.rb
          test/retest/file_system_test.rb
          test/retest/program_test.rb
          test/retest/prompt_test.rb
          test/retest/repository_test.rb
          test/retest/runner_test.rb
          test/retest/setup_test.rb
        ])
        @runner = EmptyRunner.new
        @subject = Program.new(runner: @runner, repository: @repository, stdout: StringIO.new)
      end

      def check_runner_runs_files(files, journal: @runner.journal)
        assert_equal [
          {
            method: :run,
            args: [],
            kwargs: { test_files: files }
          }
        ], journal
      end

      def test_program_forced_selection_enabled
        @subject.force_batch(<<~INPUT)
          test/retest/command/ruby_test.rb
          test/retest/file_system_test.rb
        INPUT

        assert @subject.forced_selection?
        assert_equal %w[
          test/retest/command/ruby_test.rb
          test/retest/file_system_test.rb
        ], @subject.selected_test_files
      end

      def test_happy_path_known_test_files
        @subject.force_batch(<<~INPUT)
          test/retest/command/ruby_test.rb
          test/retest/command_test.rb
          test/retest/file_system_test.rb
          test/retest/program_test.rb
          test/retest/prompt_test.rb
        INPUT

        check_runner_runs_files(%w[
          test/retest/command/ruby_test.rb
          test/retest/command_test.rb
          test/retest/file_system_test.rb
          test/retest/program_test.rb
          test/retest/prompt_test.rb
        ])
      end

      def test_unknown_test_paths
        @subject.force_batch(<<~INPUT)
          test/retest/command_test.rb
          test/retest/file_system_test.rb
          test/retest/UNKNOWN_TEST.rb
        INPUT

        check_runner_runs_files(%w[
          test/retest/command_test.rb
          test/retest/file_system_test.rb
        ])
      end

      def test_incomplete_test_paths
        @subject.force_batch(<<~INPUT)
          test/retest/command_test.rb
          file_system_test.rb
        INPUT

        check_runner_runs_files(%w[
          test/retest/command_test.rb
          test/retest/file_system_test.rb
        ])
      end

      def test_multiple_same_test_paths
        @subject.force_batch(<<~INPUT)
          test/retest/command_test.rb
          test/retest/command_test.rb
          test/retest/file_system_test.rb
          retest/file_system_test.rb
          file_system_test.rb
        INPUT

        expected_test_files = %w[
          test/retest/command_test.rb
          test/retest/file_system_test.rb
        ]

        check_runner_runs_files(expected_test_files)
      end

      def test_changed_files_identification
        # Match normal ruby files and select their matching test files
        @subject.force_batch(<<~INPUT)
          command.rb
          lib/retest/file_system.rb
          command/rake.rb
          command/rake_test.rb
          command/rspec.rb
          lib/retest/special_unknown_folder/runner.rb
        INPUT

        expected_test_files = %w[
          test/retest/command/rake_test.rb
          test/retest/command/rspec_test.rb
          test/retest/command_test.rb
          test/retest/file_system_test.rb
          test/retest/runner_test.rb
        ]

        check_runner_runs_files(expected_test_files)
      end
    end

    class PauseTest < Minitest::Test
      def setup
        @subject = Program.new(repository: Repository.new, stdout: StringIO.new)
      end

      def test_paused?
        refute @subject.paused?

        @subject.pause
        assert @subject.paused?

        @subject.resume
        refute @subject.paused?
      end

      def test_no_run_when_paused
        @subject.runner = RaisingRunner.new
        @subject.pause
        @subject.run('file_path')
      end

      def test_run_not_trigger_repository_find_test_when_hardcoded
        @runner = Runner.new(Command::Hardcoded.new(command: 'echo <changed>'))
        @repository = RaisingRepository.new
        @subject = Program.new(runner: @runner, repository: @repository)

        capture_subprocess_io { @subject.run('path.rb') }
      end
    end

    class QueueTest < Minitest::Test
      class SlowRunner
        attr_reader :journal

        def initialize
          @journal = []
          @running = Queue.new
          @continue = Queue.new
        end

        def has_test?
          true
        end

        def run(*args, **kwargs)
          @journal << { method: __method__, args: args, kwargs: kwargs }
          @running.push(true)
          @continue.pop
        end

        def wait_until_running
          @running.pop
        end

        def continue_running
          @continue.push(true)
        end
      end

      class Repository
        def find_test(file)
          "#{file.sub('.rb', '')}_test.rb"
        end
      end

      def setup
        @runner = SlowRunner.new
        @subject = Program.new(runner: @runner, repository: Repository.new, stdout: StringIO.new)
      end

      def test_keeps_the_latest_queued_file_when_a_run_is_already_active
        running_thread = Thread.new { @subject.run('first.rb') }

        @runner.wait_until_running
        @subject.run('second.rb')
        @subject.run('latest.rb')

        @runner.continue_running
        @runner.wait_until_running
        @runner.continue_running
        running_thread.join

        assert_equal [
          {
            method: :run,
            args: [],
            kwargs: { changed_files: ['first.rb'], test_files: ['first_test.rb'] }
          },
          {
            method: :run,
            args: [],
            kwargs: { changed_files: ['latest.rb'], test_files: ['latest_test.rb'] }
          }
        ], @runner.journal
      end
    end
  end
end
