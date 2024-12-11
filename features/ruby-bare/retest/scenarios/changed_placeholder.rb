class ChangedPlaceholder < Minitest::Test
  include RetestHelper

  def setup
    @command = %Q{retest 'echo file modified: <changed>'}
  end

  def teardown
    end_retest
  end

  def test_file_modification
    launch_retest @command

    assert_output_matches <<~OUTPUT
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('program.rb')

    assert_output_matches <<~EXPECTED
      Changed file: program.rb

      file modified: program.rb
    EXPECTED
  end
end