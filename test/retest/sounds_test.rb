require 'test_helper'
require_relative 'runners/observable_runner'

module Retest
  class SoundsTest < MiniTest::Test
    include Runners::ObserverInterfaceTests

    def setup
      @subject = Sounds.new
    end

    class FakeThread
      def initialize(&block)
        block.call
      end
    end

    def test_play_tests_pass
      kernel = MiniTest::Mock.new
      kernel.expect(:system, true, ['afplay', '/System/Library/Sounds/Funk.aiff'])

      Sounds.new(kernel: kernel, thread: FakeThread).play(:tests_pass)

      kernel.verify
    end

    def test_play_tests_fail
      kernel = MiniTest::Mock.new
      kernel.expect(:system, true, ['afplay', '/System/Library/Sounds/Sosumi.aiff'])

      Sounds.new(kernel: kernel, thread: FakeThread).play(:tests_fail)

      kernel.verify
    end
  end
end