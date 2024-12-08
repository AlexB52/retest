require 'retest'
require_relative 'support/test_helper'
require 'minitest/autorun'

$stdout.sync = true

class MatchingTestsCommandTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest --rspec'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_output_matches <<~EXPECTED
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modify_a_file
    launch_retest @command

    modify_file 'app/models/post.rb'

    assert_output_matches(
      "Test file: spec/models/post_spec.rb",
      "2 examples, 0 failures")
  end
end

class AllTestsCommandTest < Minitest::Test
  include RetestHelper

  def setup
    @command = 'retest --rspec --all'
  end

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest @command

    assert_output_matches <<~EXPECTED
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED
  end

  def test_modify_a_file
    launch_retest @command

    modify_file 'app/models/post.rb'

    assert_output_matches "9 examples, 0 failures"
  end
end

class AutoFlagTest < Minitest::Test
  include RetestHelper

  def teardown
    end_retest
  end

  def test_with_no_command
    launch_retest 'retest'

    assert_output_matches <<~OUTPUT
      Setup identified: [RSPEC]. Using command: 'bundle exec rspec <test>'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end

  def test_with_no_command_all
    launch_retest 'retest --all'

    assert_output_matches <<~OUTPUT
      Setup identified: [RSPEC]. Using command: 'bundle exec rspec'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end
end

class SetupTest < Minitest::Test
  def test_repository_setup
    assert_equal :rspec, Retest::Setup.new.type
  end
end
