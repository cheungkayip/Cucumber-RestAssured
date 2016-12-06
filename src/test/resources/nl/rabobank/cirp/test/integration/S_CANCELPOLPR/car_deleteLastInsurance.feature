# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# http://jira.rabobank.nl/browse/VKVMINION-1451
# TESTCASE CAR 0801 EXISTING Policy DELETE Insurance Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
Feature: car_deleteLastInsurance

  Scenario: Login with PhilTheMinion
    Given I want to login with user "PhilTheMinion"
    Then response should have status code "302"

  Scenario: Start a Car disconnect flow
    Given I start a flowType "DISCONNECT" flow and productTypeCode "0801" and overeenkomstId "666666" and object "CR4444"
    Then response should have status code "200"

  Scenario: GET Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinue" endpoint
    Then response should have status code "200"

  Scenario: POST Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinueAnswers" endpoint for payload:
    """
    {"discontinueDate":"dateChange"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value            |
      | RelationId                                           | 999990000000771  |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_CANCELPOLPR    |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | BPCNCLPOLPR      |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange       |
