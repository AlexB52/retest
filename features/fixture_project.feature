Feature: FixtureProject
  In order to refactor a Ruby project
  As a CLI
  I want to have a Ruby Project setup

  Scenario: Broccoli is gross
    Given I cd in a ruby project with tests
    When I run `bundle exec rake test`
    Then the output should contain "4 runs, 0 assertions, 0 failures, 0 errors, 0 skips"
