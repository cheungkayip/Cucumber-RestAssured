# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# http://jira.rabobank.nl/browse/VKVMONSTER-2473
# TESTCASE HOME 0809 EXISTING Policy NEW CustomerValues Simulating the GET and POST actions that happens through the application
# CustomerValues should be filled with their none-customer counterparts
Feature: home_existing_newCustomerValue

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "AutoMate"
    Then response should have status code "302"

  Scenario: Start Home
    Given With an Existing Policy I create a "NEW" flow and overeenkomstId "333334" and productCode "0809"
    Then response should have status code "200"

  Scenario: GET Uw Woning Address
    Given I compose "damage-insurance-aiep-address-address" endpoint
    Then response should have status code "200"

  Scenario: GET Uw Woning Basic
    Given I compose "configure-home-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST Uw Woning AddressAnswers Changed buildingType + roofType
    Given I compose "damage-insurance-aiep-address-addressAnswers" endpoint for payload:
    """
    {"postalCode":"1111AA","houseNumber":"1","buildingType":"9020103","roofType":"05","multipleAddressIndex":null}
    """
    Then response should have status code "200"

  Scenario: POST Basis gegevens no change here
    Given I compose "configure-home-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"13-08-2016","houseHold":"02"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-home-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST premium calculation
    Given I compose "configure-home-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: POST selected coverage endpoint
    Given I compose "configure-home-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["Home"],"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: GET Home use endpoint
    Given I compose "configure-home-insurance-home_use" endpoint
    Then response should have status code "200"


  Scenario: GET Summarize open
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"


  Scenario: POST Summarize save SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                           | value           |
      | RelationId                     | 999990000000208 |
      | NVP:CustomerWozValueAmount     | 120000          |
      | NVP:CustomerMainBuildingVolume | 200             |
      | NVP:CustomerYearOfManufacture  | 2000            |
      | NVP:WozValueAmount             | 120000          |
      | NVP:MainBuildingVolume         | 200             |

