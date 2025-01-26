require 'retest'
require_relative 'support/test_helper'
require 'minitest/autorun'
require_relative 'retest_test/file_changes'

$stdout.sync = true

class TestDefaultCommand < Minitest::Test
  include RetestHelper
  include FileChanges

  def setup
    @command = "retest"
  end

  def teardown
    end_retest
  end

  def test_repository_setup
    assert_equal :rspec, Retest::Setup.new.type
  end

  def test_starting_details
    launch_retest @command

    assert_output_matches <<~OUTPUT
      Setup: [RSPEC]
      Command: 'bundle exec rspec <test>'
      Watcher: [LISTEN]

      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('lib/bottles.rb')

    assert_output_matches "Test file: spec/bottles_spec.rb"
  end
end

class TestAliasCommand < Minitest::Test
  include RetestHelper
  include FileChanges

  def setup
    @command = "retest --rspec 'bin/retest <test>'"
  end

  def teardown
    end_retest
  end

  def test_repository_setup
    assert_equal :rspec, Retest::Setup.new.type
  end

  def test_starting_details
    launch_retest @command

    assert_output_matches <<~OUTPUT
      Setup: [RSPEC]
      Command: 'bin/retest <test>'
      Watcher: [LISTEN]

      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('lib/bottles.rb')

    assert_output_matches "Test file: spec/bottles_spec.rb"
  end
end
