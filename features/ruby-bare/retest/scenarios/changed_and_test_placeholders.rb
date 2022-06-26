class ChangedAndTestPlaceholders < Minitest::Test
  def setup
    @command = %Q{retest 'echo placeholders: <changed> and <test>'}
  end

  def teardown
    end_retest @output, @pid
  end

  def test_file_modification
    @output, @pid = launch_retest @command

    assert_match <<~OUTPUT, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('program.rb')

    assert_match <<~EXPECTED, @output.read
      Files Selected:
        - changed: program.rb
        - test: program_test.rb

      placeholders: program.rb and program_test.rb
    EXPECTED
  end
end