# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# http://jira.rabobank.nl/browse/VKVMINION-1246
# TESTCASE LUGGAGE 0815 EXISTING Policy MODIFY Coverage Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
Feature: luggage_changeContinuousCoverageAmount_InsuredAmount

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Luggage modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0815" and overeenkomstId "333333" and object ""
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-luggage-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers car
    Given I compose "configure-luggage-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"01"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-luggage-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-luggage-insurance-premium-calculation" endpoint for payload:
    """
    {"continuousCoverageAmount":"10000"}
    """
    Then response should have status code "200"
    And response should be:
    """
    {"LuggageContinuous":{"amount":"17","paymentFrequency":"per jaar"}}
    """
    And XML "req" of "CalculateOrderPremium" should contain:
      | name       | value           |
      | RelationId | 999990000000204 |

# Verander hier je Continuous coverage
  Scenario: POST coverage endpoint
    Given I compose "configure-luggage-insurance-selected-coverage" endpoint for payload:
    """
    {"continuousCoverageAmount":"15000","selectedCoverages":["LuggageContinuous"]}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name       | value           |
      | RelationId | 999990000000204 |

  Scenario: POST Summarize screen SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value                                                                                                |
      | RelationId                                           | 999990000000204                                                                                      |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_COVDATA                                                                                            |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                                                                                                    |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | P_B_S_BN_PRM_AMD                                                                                     |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange                                                                                           |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | TravelLuggage-Luggage_Cirp_1-Coverage-LuggageContinuous-1TravelLuggage-Luggage_Cirp_1-Coverage-Lugga |
      | NVP:ChangeScenarioChangeActionReferenceUID_2_001001  | geContinuous-2                                                                                       |
      | NVP:ChangeScenarioChangeScenarioCode2                | null                                                                                                 |
