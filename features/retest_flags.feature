Feature: FixtureProject
  In order to refactor a Ruby project quicker
  I want to run a command with a flag to set my command

  Scenario: I can run retest with no command
    Given I run retest with "exe/retest"
    And I modify file "test/fixtures/files/unmatched_file.txt"
    Then the logger should output:
    """
    You have no command assigned

    """

  Scenario: I can run retest with a --rake flag
    Given I run retest with "exe/retest --rake"
    And I modify file "test/fixtures/files/ruby/file.rb"
    Then the logger should output:
    """
    1 runs, 1 assertions, 0 failures, 0 errors, 0 skips

    """

  Scenario: I can run retest with a --rake --all flag
    Given I run retest with "exe/retest --rake --all"
    And I modify file "test/fixtures/files/ruby/file.rb"
    Then the logger should output a successful run

  Scenario: I can run retest with a --ruby flag
    Given I run retest with "exe/retest --ruby"
    And I modify file "test/fixtures/files/ruby/file.rb"
    Then the logger should output:
    """
    1 runs, 1 assertions, 0 failures, 0 errors, 0 skips

    """

  # Scenario: I can run retest with a --rails flag
  #   Given I run retest with "exe/retest --rails"
  #   And I modify file "test/fixtures/files/matched_file.txt"
  #   Then the logger should output:
  #   """
  #   Test File Selected: test/fixtures/files/matched_file_test.txt
  #   some error

  #   """
  # Scenario: I can run retest with a --rspec flag
  #   Given I run retest with "exe/retest --rspec"
  #   And I modify file "test/fixtures/files/matched_file.txt"
  #   Then the logger should output:
  #   """
  #   Test File Selected: test/fixtures/files/matched_file_test.txt
  #   some error

  #   """