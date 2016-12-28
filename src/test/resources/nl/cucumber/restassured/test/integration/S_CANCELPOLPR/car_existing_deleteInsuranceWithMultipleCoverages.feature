
# TESTCASE CAR 0801 EXISTING Policy DELETE Insurance Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
Feature: car_existing_deleteInsuranceWithMultipleCoverages

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Car modify flow
    Given I start a flowType "DISCONNECT" flow and productTypeCode "0801" and overeenkomstId "333333" and object "CR1111"
    Then response should have status code "200"

  Scenario: GET Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinue" endpoint
    Then response should have status code "200"

  Scenario: POST Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinueAnswers" endpoint for payload:
    """
    {"discontinueDate":"01-01-2017"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value            |
      | RelationId                                           | 999990000000204  |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_CANCELPOLPR    |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | BPCNCLPOLPR      |
      | NVP:ChangeScenarioChangeActionDate001001             | 01/01/2017       |
      | NVP:ChangeScenarioChangeActionChangeActionCode001002 | BPCNCLPOLPR      |
      | NVP:ChangeScenarioChangeActionDate001002             | 01/01/2017       |
      | NVP:ChangeScenarioChangeScenarioCode2                | null    |
