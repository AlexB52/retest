require 'test_helper'

module Retest
  class ProgramTest < MiniTest::Test
    def setup
      @subject = Program.new
    end

    def test_listen
      listener = MiniTest::Mock.new
      expected_options = {relative: true, only: Regexp.new('\\.rb$'), force_polling: false}

      listener.expect(:to, Struct.new(:start).new, ['.', expected_options])

      @subject.listen(Options.new, listener: listener)

      listener.verify
    end

    def test_listen_when_polling
      listener = MiniTest::Mock.new
      expected_options = {relative: true, only: Regexp.new('\\.rb$'), force_polling: true}

      listener.expect(:to, Struct.new(:start).new, ['.', expected_options])

      @subject.listen(Options.new(["--polling"]), listener: listener)

      listener.verify
    end
  end
end