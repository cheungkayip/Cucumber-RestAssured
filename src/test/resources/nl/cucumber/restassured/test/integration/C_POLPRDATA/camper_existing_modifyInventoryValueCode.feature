
# TESTCASE CAMPER 0805 InventoryValueCode from 02 to 01
@ChangeScenario
@C_POLPRDATA
Feature: camper_existing_modifyInventoryValueCode

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Camper modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0805" and overeenkomstId "333333" and object "CM1111"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-camper-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers camper with licencePlate
    Given I compose "configure-camper-insurance-licenseAnswers" endpoint for payload:
    """
    {"licensePlate":"CM1111","yearOfPurchase":"2010","acquisitionCost":10000,"inventoryValue":"01","yearOfManufacture":"2008","weight":2970}
    """
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-camper-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers camper
    Given I compose "configure-camper-insurance-basicAnswers" endpoint for payload:
    """
    {"driverAnswers":{"regularDriverCode":"0001","birthDate":"13-05-1995","initials":"M.I.N","genderCode":"1","surname":"Geel","relationToDriver":null},"startDate":"dateChange","claimFreeYears":"10"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-camper-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-camper-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: POST coverage endpoint
    Given I compose "configure-camper-insurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"LiabilityCasco"}
    """
    Then response should have status code "200"

  Scenario: POST additional endpoint
    Given I compose "configure-camper-insurance-save-model" endpoint for payload:
    """
    {"additionalCoverages":["PassengerInjuries","NoClaimProtection"]}
    """
    Then response should have status code "200"

  Scenario: GET checkcode endpoint
    Given I compose "common-checkcode-view" endpoint
    Then response should have status code "200"

  Scenario: POST checkcode (Meldcode) endpoint
    Given I compose "common-checkcode-answers" endpoint for payload:
    """
    {"checkCode":"1234"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                                 | value           |
      | RelationId                                           | 999990000000204 |

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                     | value                      |
      | RelationId                                               | 999990000000204            |
      | NVP:ChangeScenarioChangeScenarioCode1                    | C_POLPRDATA                |
      | NVP:ChangeScenarioSequenceNumber1                        | 1                          |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001     | ZP_B_S_POLPRDATA_AMD       |
      | NVP:ChangeScenarioChangeActionDate001001                 | dateChange                 |
      | NVP:ChangeScenarioChangeScenarioCode2                    | null                       |