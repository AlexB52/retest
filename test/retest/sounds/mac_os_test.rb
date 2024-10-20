require 'test_helper'
require_relative './sounds_interface'

module Retest
  module Sounds
    class MacOSTests < Minitest::Test
      include SoundsInterfaceTests

      def setup
        @subject = MacOS.new
      end

      class FakeThread
        def initialize(&block)
          block.call
        end
      end

      def test_play_tests_pass
        kernel = Minitest::Mock.new
        kernel.expect(:system, true, ['afplay', '/System/Library/Sounds/Funk.aiff'])

        MacOS.new(kernel: kernel, thread: FakeThread).play(:tests_pass)

        kernel.verify
      end

      def test_play_tests_fail
        kernel = Minitest::Mock.new
        kernel.expect(:system, true, ['afplay', '/System/Library/Sounds/Sosumi.aiff'])

        MacOS.new(kernel: kernel, thread: FakeThread).play(:tests_fail)

        kernel.verify
      end

      def test_play_question
        kernel = Minitest::Mock.new
        kernel.expect(:system, true, ['afplay', '/System/Library/Sounds/Glass.aiff'])

        MacOS.new(kernel: kernel, thread: FakeThread).play(:question)

        kernel.verify
      end

      def test_play_start
        kernel = Minitest::Mock.new
        kernel.expect(:system, true, ['afplay', '/System/Library/Sounds/Blow.aiff'])

        MacOS.new(kernel: kernel, thread: FakeThread).play(:start)

        kernel.verify
      end
    end
  end
end
