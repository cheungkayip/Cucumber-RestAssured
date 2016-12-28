
# TESTCASE TRAILER 0806 Change Insured Object
@S_SUBJECT
Feature: trailer_existing_modifyChangeInsuredObject

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start Trailer
    Given I start a flowType "MODIFY" flow and productTypeCode "0806" and overeenkomstId "333333" and object "WA1111_"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-trailer-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers trailer with licencePlate
    Given I compose "configure-trailer-insurance-licenseAnswers" endpoint for payload:
    """
    {"sameLicensePlateAsCar":"false","licensePlate":"wa1111","chassisNumber":null}
    """
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-trailer-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basisAnswers trailer
    Given I compose "configure-trailer-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","yearOfConstruction":"2010","yearOfAcquisition":"2010","acquisitionCost":"10000","owner":"true"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-trailer-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-trailer-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"


  Scenario: POST to selected coverage
    Given I compose "configure-trailer-insurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"LiabilityCasco"}
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
      | NVP:ChangeScenarioChangeScenarioCode2                | null                         |
