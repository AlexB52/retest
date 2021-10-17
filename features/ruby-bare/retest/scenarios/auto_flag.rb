class AutoFlag < Minitest::Test
  def test_start_retest
    @output, @pid = launch_retest 'retest'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RUBY]. Using command: 'ruby <test>'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('program.rb')

    assert_match "Test File Selected: program_test.rb", @output.read

    end_retest @output, @pid
  end
end