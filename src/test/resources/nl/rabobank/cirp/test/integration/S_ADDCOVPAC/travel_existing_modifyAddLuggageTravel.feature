# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# http://jira.rabobank.nl/browse/VKVMINION-1240
# TESTCASE MOPED 0803 EXISTING Policy MODIFY Insurance ADD ADDITIONAL ROAD ASSISTANCE Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
Feature: travel_existing_modifyAddLuggageTravel

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Travel modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0814" and overeenkomstId "333333" and object ""
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-travel-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers travel
    Given I compose "configure-travel-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"01","travelDurationUninterrupted":"03","coverageAreaCodeFlag":"true","winterAndUnderwaterSportsFlag":"true","businessTravelFlag":"true","studentFlag":"false"}
    """
    Then response should have status code "200"

  Scenario: POST coverage endpoint
    Given I compose "configure-travel-insurance-coverage" endpoint for payload:
    """
    """
    Then response should have status code "200"

  Scenario: POST CalculateOrderPremium request
    Given I compose "configure-travel-insurance-premium-calculation" endpoint for payload:
    """
    {"cancellationTravelAmount":"1","luggageTravelAmount":"3000"}
    """
    Then response should have status code "200"

  Scenario: POST selected coverage endpoint
    Given I compose "configure-travel-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["TravelPersonalAssistance","TravelMedical","BreakdownAssistanceVehicle","LuggageTravel"],"luggageTravelAmount":"6000"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                                 | value           |
      | RelationId                                           | 999990000000204 |

  Scenario: POST Summarize screen SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                     | value              |
      | RelationId                                               | 999990000000204    |
      | NVP:ChangeScenarioChangeScenarioCode1                    | S_ADDCOVPAC        |
      | NVP:ChangeScenarioSequenceNumber1                        | 1                  |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001     | P_B_S_BTX_COVPAC   |
      | NVP:ChangeScenarioChangeActionDate001001                 | dateChange         |
      | NVP:ChangeScenarioChangeScenarioCode2                    | null               |
