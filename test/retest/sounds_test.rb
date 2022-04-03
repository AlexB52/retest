require 'test_helper'

module Retest
  class SoundsTest < MiniTest::Test
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