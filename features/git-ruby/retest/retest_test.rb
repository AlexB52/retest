require_relative 'test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class FileChangesTest < Minitest::Test
  def setup
    @command = 'retest --ruby'
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

class GitChangesTest < Minitest::Test
  def setup
    @command = 'retest --diff=main --ruby'
  end

  def teardown
  end

  def test_diffs_from_other_branch
    `git checkout -b feature-branch`
    
  end
end