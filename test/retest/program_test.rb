require 'test_helper'

# TODO : write missing tests
module Retest
  class ProgramTest < MiniTest::Test
    class PauseTest < Minitest::Test
      def setup
        @subject = Program.new
      end

      def test_paused?
        refute @subject.paused?

        @subject.pause
        assert @subject.paused?

        @subject.resume
        refute @subject.paused?
      end
    end
  end
end
