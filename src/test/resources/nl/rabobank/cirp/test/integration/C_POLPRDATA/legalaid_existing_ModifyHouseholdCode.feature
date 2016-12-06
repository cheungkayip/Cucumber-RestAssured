# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# TESTCASE HOME 0809 EXISTING Policy MODIFY Household Code Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
@C_POLPRDATA
Feature: legalaid_existing_ModifyHouseholdCode

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Home modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0816" and overeenkomstId "333333" and object ""
    Then response should have status code "200"

  Scenario: GET Uw Legal aid Basic
    Given I compose "configure-legalaid-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST Uw Legal aid BasicAnswers
    Given I compose "configure-legalaid-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"02"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-legalaid-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST selected coverage endpoint
    Given I compose "configure-legalaid-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["LegalBasis","LegalConsumerAndHousing","LegalWorkAndIncome","LegalFiscalAndAssets"]}
    """
    Then response should have status code "200"


  Scenario: GET Summarize open ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000204 |

  Scenario: POST Summarize save SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                     | value                        |
      | RelationId                                               | 999990000000204              |
      | NVP:ChangeScenarioChangeScenarioCode1                    | C_POLPRDATA                  |
      | NVP:ChangeScenarioSequenceNumber1                        | 1                            |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001     | ZP_B_S_POLPRDATA_AMD         |
      | NVP:ChangeScenarioChangeActionDate001001                 | dateChange                   |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001      | LegalAssist-01LegalAssist-02 |