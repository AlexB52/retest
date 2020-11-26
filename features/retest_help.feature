Feature: Retest CLI help option
  Scenario: I can print help with --help
    Given I run retest with "exe/retest --help"
    Then the logger should output the help

  Scenario: I can print help with -h
    Given I run retest with "exe/retest -h"
    Then the logger should output the help

  Scenario: I do not start retest
    Given I run retest with "exe/retest -h"
    Then the logger should not output:
    """
    Launching Retest...
    Ready to refactor! You can make file changes now

    """
