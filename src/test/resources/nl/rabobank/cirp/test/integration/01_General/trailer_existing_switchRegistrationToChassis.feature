# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# TESTCASE TRAILER 0806 switch from RegistrationNumber to ChassisNumber
# Chain bug http://jira.rabobank.nl/browse/VKVMINION-1981
@regression
Feature: trailer_existing_switchRegistrationToChassis

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start Trailer
    Given I start a flowType "MODIFY" flow and productTypeCode "0806" and overeenkomstId "333333" and object "TRA111_"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-trailer-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers trailer with licencePlate
    Given I compose "configure-trailer-insurance-licenseAnswers" endpoint for payload:
    """
    {"sameLicensePlateAsCar":"true","licensePlate":"TRA111","chassisNumber":"445566"}
    """
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-trailer-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basisAnswers trailer
    Given I compose "configure-trailer-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"01-01-2017","yearOfConstruction":"2008","yearOfAcquisition":"2013","acquisitionCost":"75","owner":"true"}
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
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                                                 | value           |
      | NVP:ChassisNumber                                    | 445566 |


  Scenario: POST to selected coverage
    Given I compose "configure-trailer-insurance-selected-coverage" endpoint for payload:
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
      | name                                                 | value           |
      | RelationId                                           | 999990000000204 |
