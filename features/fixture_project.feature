Feature: FixtureProject
  In order to refactor a Ruby project
  As a CLI
  I want to have a Ruby Project setup

  Scenario: I can run tests
    Given I cd in a ruby project with tests
    When I run `bundle exec rake test`
    Then the output should contain "4 runs, 0 assertions, 0 failures, 0 errors, 0 skips"

  Scenario: I can see the project
    Given I cd in a ruby project with tests
    When I run `ls`
    Then the output should contain:
    """
    Gemfile
    Rakefile
    lib
    test
    """
