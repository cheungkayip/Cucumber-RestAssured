
# TESTCASE LUGGAGE 0815 EXISTING Policy MODIFY Coverage Simulating the GET and POST actions that happens through the application

@Integration
@ChangeScenario
@S_COVDATA
Feature: travel_modifyTravelCoverageAmountOnly_InsuredAmount

  Scenario: Authorize with user Randall Boggs
    Given I want to login with user "RandallBoggs"
    Then response should have status code "302"

  Scenario: Start a Luggage modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0814" and overeenkomstId "777777" and object ""
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-travel-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers travel
    Given I compose "configure-travel-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"02","travelDurationUninterrupted":"03","coverageAreaCodeFlag":"true","winterAndUnderwaterSportsFlag":"true","businessTravelFlag":"true","studentFlag":"true"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-travel-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-travel-insurance-premium-calculation" endpoint for payload:
    """
    {"cancellationTravelAmount":"3","luggageTravelAmount":"10000"}
    """
    Then response should have status code "200"
    And XML "req" of "CalculateOrderPremium" should contain:
      | name       | value           |
      | RelationId | 999990000000772 |

  Scenario: POST coverage endpoint
    Given I compose "configure-travel-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["TravelCancellation","TravelPersonalAssistance","LuggageTravel"],"cancellationTravelAmount":"3","luggageTravelAmount":"24000"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name       | value           |
      | RelationId | 999990000000772 |

  Scenario: POST Summarize screen SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value                           |
      | RelationId                                           | 999990000000772                 |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_COVDATA                       |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                               |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | P_B_S_BN_PRM_AMD                |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange                      |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | xPM0/ABDACOVPAC;000000000100006 |
      | NVP:ChangeScenarioChangeScenarioCode2                | null                            |