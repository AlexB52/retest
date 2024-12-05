require 'retest'
require 'byebug'
require 'minitest/autorun'
require_relative 'support/test_helper'
require_relative 'shared/file_changes'
require_relative 'shared/setup'
require_relative 'shared/explicit_matching'

$stdout.sync = true

class TestListenWatcher <  Minitest::Test
  # Helpers
  include FileHelper
  include OutputHelper
  include CommandHelper

  # Assertions
  include Setup
  include FileChanges
  include ExplicitMatching

  def setup
    @command = 'retest -w listen'
  end

  def test_start_retest
    launch_retest(@command)

    assert_match <<~EXPECTED, read_output
      Setup identified: [RUBY]. Using command: 'bundle exec ruby <test>'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end

class TestWatchexecWatcher <  Minitest::Test
  # Helpers
  include FileHelper
  include OutputHelper
  include CommandHelper

  # Assertions
  include Setup
  include FileChanges
  include ExplicitMatching

  def setup
    @command = 'retest -w watchexec'
  end

  def test_start_retest
    launch_retest(@command)

    assert_match <<~EXPECTED, read_output
      Setup identified: [RUBY]. Using command: 'bundle exec ruby <test>'
      Watcher: [WATCHEXEC]
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end

class TestDefaultWatcher <  Minitest::Test
  include OutputHelper
  include CommandHelper

  def setup
    @command = 'retest'
  end

  def test_uses_watchexec_when_installed
    launch_retest(@command)

    assert_match <<~EXPECTED, read_output
      Setup identified: [RUBY]. Using command: 'bundle exec ruby <test>'
      Watcher: [WATCHEXEC]
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end
