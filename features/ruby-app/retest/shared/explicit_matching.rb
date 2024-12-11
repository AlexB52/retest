module ExplicitMatching
  def teardown
    end_retest
  end

  def test_displaying_options_on_matching_command
    create_file('test/other_bottles_test.rb', sleep_for: 0)

    launch_retest(@command)

    create_file 'foo_test.rb'
    assert_output_matches "Test file: foo_test.rb"

    modify_file('lib/bottles.rb')
    assert_output_matches <<~EXPECTED.chomp
      We found few tests matching: lib/bottles.rb

      [0] - test/bottles_test.rb
      [1] - test/other_bottles_test.rb
      [2] - none

      Which file do you want to use?
      Enter the file number now:
      >
    EXPECTED

    write_input("2\n")
    assert_output_matches "Test file: foo_test.rb"

  ensure
    delete_file 'foo_test.rb'
    delete_file('test/other_bottles_test.rb')
  end
end
