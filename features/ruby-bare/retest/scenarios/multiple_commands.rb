class ChangedAndTestPlaceholders < Minitest::Test
  def setup
    @command = %Q{retest 'echo files: <changed> and <test> && echo hello world'}
  end

  def teardown
    end_retest
  end

  def test_file_modification
    launch_retest @command

    assert_match <<~OUTPUT, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('program.rb')

    assert_match <<~EXPECTED, @output.read
      Changed file: program.rb
      Test file: program_test.rb

      files: program.rb and program_test.rb
      hello world
    EXPECTED
  end
end