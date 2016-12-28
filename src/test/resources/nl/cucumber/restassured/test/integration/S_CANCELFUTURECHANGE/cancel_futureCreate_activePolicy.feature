# TC where a future create on an active policy is being disconnected> this is the only scenario where this CS should be triggered
@Integration
@ChangeScenario
@S_CANCELFUTURECHANGE
Feature: cancel_futureCreate_activePolicy

  Scenario: Authorize with user TimTheMinion
    Given I want to login with user "TimTheMinion"
    Then response should have status code "302"

  Scenario: Start Car future create
    Given I start a flowType "DISCONNECT" flow and productTypeCode "0801" and overeenkomstId "888888" and effectiveDate "2017-11-08" and object "CR2222"
    Then response should have status code "200"

  Scenario: GET Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinue" endpoint
    Then response should have status code "200"

  Scenario: POST Opzeggen Lamel
    Given I compose "damage-insurance-aiep-discontinue-discontinueAnswers" endpoint for payload:
    """
    {"discontinueDate":"08-11-2017"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000117 |

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                     | value                      |
      | RelationId                                               | 999990000000117            |
      | NVP:BTSDateUID_1_1                                       | BTS-UID-Car_Cirp_2_1-1BTS-UID-Car_Cirp_2_2-1 |
      | NVP:BTSDateEffectiveDate1                                | 11/08/2017                 |
      | NVP:BTSDateBusinessTransactionID1                        | P_B_S_POLPR_CRT            |
      | NVP:BTSDateUID_1_2                                       | BTS-UID-RoadSideAssistCar_Cirp_2_1-2BTS-UID-RoadSideAssistCar_Cirp_2_2-2 |
      | NVP:BTSDateEffectiveDate2                                | 11/08/2017                 |
      | NVP:BTSDateBusinessTransactionID2                        | P_B_S_POLPR_CRT            |
      | NVP:ChangeScenarioChangeScenarioCode1                    | S_CANCELFUTURECHANGE       |
      | NVP:ChangeScenarioSequenceNumber1                        | 1                          |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001     | CANCELBTSDATE              |
      | NVP:ChangeScenarioChangeActionDate001001                 | 11/08/2017                 |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001      | BTS-UID-Car_Cirp_2_1-1BTS-UID-Car_Cirp_2_2-1 |
      | NVP:ChangeScenarioChangeActionChangeActionCode001002     | CANCELBTSDATE              |
      | NVP:ChangeScenarioChangeActionDate001002                 | 11/08/2017                 |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001002      | BTS-UID-RoadSideAssistCar_Cirp_2_1-2BTS-UID-RoadSideAssistCar_Cirp_2_2-2 |
      | NVP:ChangeScenarioChangeScenarioCode2                    | null                       |