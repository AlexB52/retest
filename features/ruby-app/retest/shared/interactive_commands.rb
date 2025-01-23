module InteractiveCommands
  def teardown
    end_retest
  end

  def test_run_all_logs_proper_error_message
    launch_retest(@command)

    write_input("\n") # Trigger last command when no command was run

    assert_output_matches("Error - Not enough information to run a command. Please trigger a run first.")
  end
end
