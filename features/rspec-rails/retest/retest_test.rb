require_relative 'test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class MatchingTestsCommandTest < Minitest::Test
  def setup
    @command = 'retest --rspec'
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

  def test_modify_a_file
    @output, @pid = launch_retest @command

    modify_file 'app/models/post.rb'

    assert_match "Test File Selected: spec/models/post_spec.rb", @output.read
    assert_match "2 examples, 0 failures", @output.read
  end
end

class AllTestsCommandTest < Minitest::Test
  def setup
    @command = 'retest --rspec --all'
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

  def test_modify_a_file
    @output, @pid = launch_retest @command

    modify_file 'app/models/post.rb'

    assert_match "9 examples, 0 failures", @output.read
  end
end

class AutoFlagTest < Minitest::Test
  def teardown
    end_retest @output, @pid
  end

  def test_with_no_command
    @output, @pid = launch_retest 'retest'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RSPEC]. Using command: 'bundle exec rspec <test>'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end

  def test_with_no_command_all
    @output, @pid = launch_retest 'retest --all'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RSPEC]. Using command: 'bundle exec rspec'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end

  def test_with_auto_flag
    @output, @pid = launch_retest 'retest --auto'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RSPEC]. Using command: 'bundle exec rspec <test>'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT
  end

  def test_with_auto_flag_all
    @output, @pid = launch_retest 'retest --auto --all'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RSPEC]. Using command: 'bundle exec rspec'
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
