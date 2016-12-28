
# TESTCASE HOME 0809 EXISTING Policy MODIFY Household Code Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
@C_POLPRDATA
Feature: inventory_existing_ModifyHouseholdCode

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Inventory modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0810" and overeenkomstId "333333" and object "1111AA_1_C_hoog"
    Then response should have status code "200"

  Scenario: GET Uw Woning Address
    Given I compose "damage-insurance-aiep-address-address" endpoint
    Then response should have status code "200"

  Scenario: GET Uw Inboedel Basic
    Given I compose "configure-inventory-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST Uw Inboedel AddressAnswers
    Given I compose "damage-insurance-aiep-address-addressAnswers" endpoint for payload:
    """
    {"postalCode":"1111AA","houseNumber":"1","buildingType":"9020205","roofType":"02","multipleAddressIndex":null}
    """
    Then response should have status code "200"

  Scenario: POST Basis gegevens Changed houseHoldcode
    Given I compose "configure-inventory-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"02","studentFlag":"true","ownerRenterCode":"1","inventoryValue":"01","lodger":"true"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-inventory-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST premium calculation
    Given I compose "configure-inventory-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: POST selected coverage endpoint
    Given I compose "configure-inventory-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["Inventory"],"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: GET Inventory use endpoint
    Given I compose "configure-inventory-insurance-inventory_use" endpoint
    Then response should have status code "200"


  Scenario: GET Summarize open ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name       | value           |
      | RelationId | 999990000000204 |


  Scenario: POST Summarize save SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value                                            |
      | RelationId                                           | 999990000000204                                  |
      | NVP:ChangeScenarioChangeScenarioCode1                | C_POLPRDATA                                      |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                                                |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | ZP_B_S_POLPRDATA_AMD                             |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange                                       |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | Inventory-Home_Cirp_2-01Inventory-Home_Cirp_2-02 |