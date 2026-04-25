class CustomExtensionTest < Minitest::Test
  include RetestHelper

  def setup
    @command = %Q{retest "echo 'I captured a change'" --exts="txt"}
  end

  def teardown
    end_retest
  end

  def test_custom_extension
    create_file 'foo.txt',     sleep_for: 0
    create_file 'foo.rb',      sleep_for: 0
    create_file 'foo_test.rb', sleep_for: 0

    launch_retest @command

    modify_file 'foo.rb'
    assert_output_matches <<~EXPECTED
      Launching Retest...
      Ready to refactor! You can make file changes now
    EXPECTED

    modify_file 'foo.txt'
    assert_output_matches "I captured a change"

  ensure
    delete_file 'foo.rb'
    delete_file 'foo_test.rb'
    delete_file 'foo.txt'
  end
end
