class CustomExtensionTest < Minitest::Test
  def setup
    @command = %Q{retest "echo 'I captured a change'" --ext="\\.txt$"}
  end

  def teardown
    end_retest @output, @pid
  end

  def test_custom_extension
    create_file 'foo.txt',     should_sleep: false
    create_file 'foo.rb',      should_sleep: false
    create_file 'foo_test.rb', should_sleep: false

    @output, @pid = launch_retest @command

    modify_file 'foo.rb'
    assert_match <<~EXPECTED, @output.read
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED

    modify_file 'foo.txt'
    assert_match "I captured a change", @output.read

    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
    delete_file 'foo.txt'
  end
end
