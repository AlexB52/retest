require 'retest'
require 'byebug'
require 'minitest/autorun'
require_relative 'support/test_helper'
require_relative 'shared/file_changes'
require_relative 'shared/setup'
require_relative 'shared/explicit_matching'
require_relative 'shared/interactive_commands'

$stdout.sync = true

class TestListenWatcher <  Minitest::Test
  include RetestHelper
  include Setup
  include ExplicitMatching
  include FileChanges
  include InteractiveCommands

  def setup
    @command = 'retest -w listen'
  end

  def test_start_retest
    launch_retest(@command)

    assert_output_matches <<~EXPECTED
      Setup: [RUBY]
      Command: 'bundle exec ruby <test>'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end

class TestWatchexecWatcher <  Minitest::Test
  include RetestHelper
  include Setup
  include ExplicitMatching
  include FileChanges
  include InteractiveCommands

  def setup
    @command = 'retest -w watchexec'
  end

  def test_start_retest
    launch_retest(@command)

    assert_output_matches <<~EXPECTED
      Setup: [RUBY]
      Command: 'bundle exec ruby <test>'
      Watcher: [WATCHEXEC]
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end

class TestDefaultWatcher <  Minitest::Test
  include RetestHelper
  include Setup
  include ExplicitMatching
  include FileChanges
  include InteractiveCommands

  def setup
    @command = 'retest'
  end

  def test_uses_watchexec_when_installed
    launch_retest(@command)

    assert_output_matches <<~EXPECTED
      Setup: [RUBY]
      Command: 'bundle exec ruby <test>'
      Watcher: [WATCHEXEC]
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end
end
