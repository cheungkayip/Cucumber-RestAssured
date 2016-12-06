# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# http://jira.rabobank.nl/browse/VKVMINION-1243
# TESTCASE TRAILER 0806 EXISTING Delete Insurance (Opzeggen) Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
Feature: trailer_existing_deleteInsurance

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start Trailer
    Given I start a flowType "DISCONNECT" flow and productTypeCode "0806" and overeenkomstId "333333" and object "WA1111_"
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

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000204 |

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                     | value                      |
      | RelationId                                               | 999990000000204            |
      | NVP:ChangeScenarioChangeScenarioCode1                    | S_CANCELPOLPR              |
      | NVP:ChangeScenarioSequenceNumber1                        | 1                          |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001     | BPCNCLPOLPR                |
      | NVP:ChangeScenarioChangeActionDate001001                 | 01/01/2017                 |
      | NVP:ChangeScenarioChangeScenarioCode2                    | null              |