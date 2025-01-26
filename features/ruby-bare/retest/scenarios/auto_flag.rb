class AutoFlag < Minitest::Test
  include RetestHelper

  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest 'retest'

    assert_output_matches <<~OUTPUT
      Setup: [RUBY]
      Command: 'ruby <test>'
      Watcher: [LISTEN]

      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('program.rb')

    assert_output_matches "Test file: program_test.rb"
  end
end