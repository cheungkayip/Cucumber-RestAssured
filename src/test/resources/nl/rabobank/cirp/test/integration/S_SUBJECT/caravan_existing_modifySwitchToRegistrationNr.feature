# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# TESTCASE CARAVAN 0813 Change Insured Object https://jira.rabobank.nl/browse/VKVMINION-1870
@ChangeScenario
@S_SUBJECT
Feature: caravan_existing_modifySwitchToRegistrationNr

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start Caravan
    Given I start a flowType "MODIFY" flow and productTypeCode "0813" and overeenkomstId "333333" and object "_KIP12345678"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configureproduct-insurance-caravaninsurance-license" endpoint
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configureproduct-insurance-caravaninsurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers caravan with chassisNumber
    Given I compose "configureproduct-insurance-caravaninsurance-licenseAnswers" endpoint for payload:
    """
    {"sameLicensePlateAsCar":"false","licensePlate":"WA-11-11","chassisNumber":"null","caravanType":"9010201","brand":"0089","yearOfConstruction":"2016","hailResistanceRoof":"false"}
    """
    Then response should have status code "200"

  Scenario: POST basisAnswers caravan
    Given I compose "configureproduct-insurance-caravaninsurance-basicAnswers" endpoint for payload:
    """
    {"yearOfAcquisition":"2016","acquisitionCost":"30000","inventoryValue":"01","startDate":"dateChange"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configureproduct-insurance-caravaninsurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configureproduct-insurance-caravaninsurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"


  Scenario: POST to selected coverage
    Given I compose "configureproduct-insurance-caravaninsurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"Casco"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value                        |
      | RelationId                                           | 999990000000204              |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_SUBJECT                    |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                            |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | P_B_S_SBJ_AMD                |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange                   |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | InsuredObject_Caravan_Cirp_1_1InsuredObject_Caravan_Cirp_1_2 |
      | NVP:ChangeScenarioChangeScenarioCode2                | null                         |
