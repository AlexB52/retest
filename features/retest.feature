Feature: FixtureProject
  In order to refactor a Ruby project
  I want to run a command when a file is modified

  Scenario: I can run retest with a hardcoded command
    Given I run retest with "echo 'hello world'"
    And I modify file "test/fixtures/files/unmatched_file.txt"
    Then the logger should output:
    """
    hello world

    """
  Scenario: I can run retest a variable command without a matching test file
    Given I run retest with "echo <test>"
    And I modify file "test/fixtures/files/unmatched_file.txt"
    Then the logger should output:
    """
    404 - Test File Not Found
    Retest could not find a matching test file to run.

    """
  Scenario: I can run retest a variable command without a matching test file
    Given I run retest with "echo <test>"
    And I modify file "test/fixtures/files/matched_file.txt"
    Then the logger should output:
    """
    Test File Selected: test/fixtures/files/matched_file_test.txt
    test/fixtures/files/matched_file_test.txt

    """