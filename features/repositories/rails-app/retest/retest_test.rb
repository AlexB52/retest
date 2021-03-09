require_relative 'test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class RailsTest < Minitest::Test
  def setup
    @command = "retest --rails"
  end

  def teardown
    end_retest @output, @pid
  end

  def test_start_retest
    @output, @pid = launch_retest @command

    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end