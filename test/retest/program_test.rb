require 'test_helper'

# TODO : write missing tests
module Retest
  class ProgramTest < MiniTest::Test
    class PauseTest < Minitest::Test
      def setup
        @subject = Program.new(repository: Repository.new, clear_window: false)
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
        @subject.run(['modified'], ['added'], ['removed'])
      end
    end
  end
end
