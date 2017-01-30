@RacesSeason2016
Feature: Test all races in Season 2016

  Scenario: Authorize with user MarkGeel
    Given I want to get all the Circuit names
    Then response should have status code "200"
    And I want to check all the circuit names are correct
    And that the total amount of races should be "21"


