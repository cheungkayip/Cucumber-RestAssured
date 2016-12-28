# TESTCASE To verify the relation id is set on the applicant in the final order
Feature: contractant_order_verification

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "AutoMate"
    Then response should have status code "302"

  Scenario: Start Trailer
    Given With an Existing Policy I create a "NEW" flow and overeenkomstId "333334" and productCode "0806"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-trailer-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers trailer with licencePlate
    Given I compose "configure-trailer-insurance-licenseAnswers" endpoint for payload:
    """
    {"sameLicensePlateAsCar":"false","licensePlate":"tra111","chassisNumber":null}
    """
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-trailer-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basisAnswers trailer
    Given I compose "configure-trailer-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"01-01-2017","yearOfConstruction":"1966","yearOfAcquisition":"1967","acquisitionCost":"455","owner":"true"}
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
    {"ownRiskType":"0","coverage":"Casco"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                    | value           |
      | Applicant:RelationId                    | 999990000000204 |
