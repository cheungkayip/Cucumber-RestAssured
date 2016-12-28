
# TESTCASE HOME 0809 EXISTING Policy MODIFY Household Code Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
@C_POLPRDATA
Feature: luggage_existing_modifyHouseholdCode

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Luggage modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0815" and overeenkomstId "333333" and object ""
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-luggage-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers luggage
    Given I compose "configure-luggage-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"03"}
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

  Scenario: POST coverage endpoint
    Given I compose "configure-luggage-insurance-selected-coverage" endpoint for payload:
    """
    {"continuousCoverageAmount":"10000","selectedCoverages":["LuggageContinuous"]}
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

  Scenario: POST Summarize save SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value                            |
      | RelationId                                           | 999990000000204                  |
      | NVP:ChangeScenarioChangeScenarioCode1                | C_POLPRDATA                      |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                                |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | ZP_B_S_POLPRDATA_AMD             |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange                       |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | TravelLuggage-Luggage_Cirp_1-01TravelLuggage-Luggage_Cirp_1-02 |
      | NVP:ChangeScenarioChangeScenarioCode2                | null                      |