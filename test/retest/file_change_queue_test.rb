require 'test_helper'

module Retest
  class FileChangeQueueTest < Minitest::Test
    def test_collapse_keeps_non_file_change_input
      assert_equal 'pause', FileChangeQueue.collapse('pause')
    end

    def test_collapse_keeps_latest_file_change
      input = <<~INPUT
        file changed: test/first_test.rb
        file changed: test/second_test.rb
        file changed: test/latest_test.rb
      INPUT

      assert_equal 'file changed: test/latest_test.rb', FileChangeQueue.collapse(input)
    end

    def test_latest_ignores_other_lines
      input = <<~INPUT
        file changed: test/first_test.rb
        Something else
        file changed: test/latest_test.rb
      INPUT

      assert_equal 'test/latest_test.rb', FileChangeQueue.latest(input)
    end
  end
end
