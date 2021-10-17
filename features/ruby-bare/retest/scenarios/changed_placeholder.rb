class ChangedPlaceholder < Minitest::Test
  def setup
    @command = %Q{retest 'echo file modified: <changed>'}
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
      Changed File Selected: program.rb
      file modified: program.rb
    EXPECTED
  end
end