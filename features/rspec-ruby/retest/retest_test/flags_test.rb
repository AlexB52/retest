class FlagTest < Minitest::Test
  include RetestHelper

  def setup
  end

  def teardown
    end_retest
  end

  def test_with_no_command
    launch_retest 'retest'

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