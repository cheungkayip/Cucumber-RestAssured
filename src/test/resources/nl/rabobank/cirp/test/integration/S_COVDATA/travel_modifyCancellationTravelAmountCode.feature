# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# http://jira.rabobank.nl/browse/VKVMINION-1246
# CancellationTravelAmountCode change 2 to 3
# TravelDurationUninterruptedCode NO CHANGE
# Make the WinterAndUnderwaterSportsFlag NO CHANGE
# TESTCASE TRAVEL 0814 EXISTING Policy MODIFY Simulating the GET and POST actions that happens through the application
@ChangeScenario
@S_COVDATA
Feature: travel_modifyCancellationTravelAmountCode

  Scenario: Authorize with user Randall Boggs
    Given I want to login with user "RandallBoggs"
    Then response should have status code "302"

  Scenario: Start a Travel modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0814" and overeenkomstId "777777" and object ""
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-travel-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers car
    Given I compose "configure-travel-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"02","travelDurationUninterrupted":"03","coverageAreaCodeFlag":"true","winterAndUnderwaterSportsFlag":"true","businessTravelFlag":"true","studentFlag":"true"}
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
    {"cancellationTravelAmount":"1","luggageTravelAmount":"10000"}
    """
    Then response should have status code "200"
    And response should be:
    """
    {"LuggageTravel":{"amount":"13","paymentFrequency":"per jaar"},"TravelCancellation":{"amount":"18","paymentFrequency":"per jaar"},"BreakdownAssistanceVehicle":{"amount":"26","paymentFrequency":"per jaar"},"TravelMedical":{"amount":"13","paymentFrequency":"per jaar"},"TravelPersonalAssistance":{"amount":"24","paymentFrequency":"per jaar"}}
    """
    And XML "req" of "CalculateOrderPremium" should contain:
      | name       | value           |
      | RelationId | 999990000000772 |

  Scenario: GET coverage endpoint
    Given I compose "configure-travel-insurance-coverage" endpoint
    Then response should have status code "200"

# Verander hier je Cancellation Travel Amount Code
  Scenario: POST coverage endpoint
    Given I compose "configure-travel-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["TravelCancellation","TravelPersonalAssistance","LuggageTravel"],"cancellationTravelAmount":"1","luggageTravelAmount":"10000"}
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
      | name                                                 | value              |
      | RelationId                                           | 999990000000772    |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_COVDATA          |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                  |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | ZP_B_S_COVDATA_AMD |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange         |
      | NVP:ChangeScenarioChangeScenarioCode2                | null               |
