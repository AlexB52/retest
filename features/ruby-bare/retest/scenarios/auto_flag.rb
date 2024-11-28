class AutoFlag < Minitest::Test
  def teardown
    end_retest
  end

  def test_start_retest
    launch_retest 'retest'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RUBY]. Using command: 'ruby <test>'
      Watcher: [LISTEN]
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('program.rb')

    assert_match "Test file: program_test.rb", @output.read
  end
end