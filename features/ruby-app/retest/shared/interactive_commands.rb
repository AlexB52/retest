module InteractiveCommands
  def teardown
    end_retest
  end

  def test_run_all_logs_proper_error_message
    launch_retest(@command)

    write_input("\n") # Trigger last command when no command was run

    assert_output_matches("Error - Not enough information to run a command. Please trigger a run first.")

    write_input("ra\n") # Trigger run all

    assert_output_matches("Command::AllTestsNotSupported - All tests run not supported for Ruby command: 'bundle exec ruby <test>'")
  end
end
