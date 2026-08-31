require 'test_helper'

module Retest
  class ProgramTest < Minitest::Test
    class TestNameOnly < Minitest::Test
      class TestRunner < EmptyRunner
        def has_test?
          true
        end
      end

      class ChangedOnlyRunner < EmptyRunner
        def has_test?
          false
        end
      end

      def setup
        @repository = Repository.new(files: %w[
          lib/bottles.rb
          test/bottles_test.rb
          test/glasses_test.rb
        ])
        @runner = TestRunner.new
        @stdout = StringIO.new
        @subject = Program.new(runner: @runner, repository: @repository, stdout: @stdout)
      end

      def test_run_prints_matching_test_without_running_command
        @subject.run('lib/bottles.rb', name_only: true)

        assert_equal "test/bottles_test.rb\n", @stdout.string
        assert_empty @runner.journal
      end

      def test_run_prints_matching_test_for_changed_only_commands
        runner = ChangedOnlyRunner.new
        subject = Program.new(runner: runner, repository: @repository, stdout: @stdout)

        subject.run('lib/bottles.rb', name_only: true)

        assert_equal "test/bottles_test.rb\n", @stdout.string
        assert_empty runner.journal
      end

      def test_run_prints_forced_selection_without_running_command
        @subject.force_selection(['test/glasses_test.rb'])
        @stdout.truncate(0)
        @stdout.rewind
        @runner.journal.clear

        @subject.run('lib/bottles.rb', name_only: true)

        assert_equal "test/glasses_test.rb\n", @stdout.string
        assert_empty @runner.journal
      end

      def test_diff_prints_matching_tests_without_running_command
        VersionControl::Git.stub(:installed?, true) do
          VersionControl::Git.stub(:diff_files, %w[lib/bottles.rb test/glasses_test.rb]) do
            @subject.diff('main', name_only: true)
          end
        end

        assert_equal "test/bottles_test.rb\ntest/glasses_test.rb\n", @stdout.string
        assert_empty @runner.journal
      end
    end

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
  end
end
