@Integration
@Discontinue
Feature: inventory_terminateInsurance

  Scenario: Login with MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Inventory disconnect flow
    Given I start a flowType "DISCONNECT" flow and productTypeCode "0810" and overeenkomstId "333333" and object "1111AA_1_C_hoog"
    Then response should have status code "200"

  Scenario: GET Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinue" endpoint
    Then response should have status code "200"

  Scenario: POST Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinueAnswers" endpoint for payload:
    """
    {"discontinueDate":"31-12-2016"}
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
      | RelationId                                           | 999990000000204  |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_CANCELPOLPR    |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | BPCNCLPOLPR      |
      | NVP:ChangeScenarioChangeActionDate001001             | 12/31/2016       |
      | NVP:ChangeScenarioChangeScenarioCode2                | null             |
