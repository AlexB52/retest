require 'test_helper'

module Retest
  class ProgramTest < Minitest::Test
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
