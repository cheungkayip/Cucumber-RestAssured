
# TESTCASE CAR 0801 EXISTING Policy MODIFY ClaimFreeYears Simulating the GET and POST actions that happens through the application
Feature: car_existing_modifyClaimFreeYears

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "PhilTheMinion"
    Then response should have status code "302"

  Scenario: Start a Car modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0801" and overeenkomstId "666666" and object "CR1111"
    Then response should have status code "200"

  Scenario: GET what to change answers endpoint
    Given I compose "configure-car-insurance-replace-vehicle" endpoint
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-car-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers car
    Given I compose "configure-car-insurance-basicAnswers" endpoint for payload:
    """
    {"driverAnswers":{"regularDriverCode":"0001","birthDate":"05-05-1969","initials":"P.","genderCode":"1","surname":"The Minion","relationToDriver":"0001"},"useOfCar":"Privé","claimFreeYears":"24","startDate":"13-08-2016"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-car-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-car-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                                                 | value           |
      | RelationId                                           | 999990000000771 |

  Scenario: POST coverage endpoint
    Given I compose "configure-car-insurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"LiabilityCascoLimited"}
    """
    Then response should have status code "200"


  Scenario: POST additional endpoint
    Given I compose "configure-car-insurance-selected-additional" endpoint for payload:
    """
    {"additionalCoverages":["NoClaimProtection","RoadAssistanceNetherlands"]}
    """
    Then response should have status code "200"

  Scenario: GET checkcode endpoint
    Given I compose "common-checkcode-view" endpoint
    Then response should have status code "200"

  Scenario: POST checkcode (Meldcode) endpoint
    Given I compose "common-checkcode-answers" endpoint for payload:
    """
    {"checkCode":"0123"}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                                 | value           |
      | RelationId                                           | 999990000000771 |

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value           |
      | RelationId                                           | 999990000000771 |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_BM            |
      | NVP:ChangeScenarioSequenceNumber1                    | 1               |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | /MVA/P_M_S_BM_AMD |
      | NVP:ChangeScenarioChangeActionDate001001             | 08/13/2016      |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | BV0luf6HzNU7PPBWv04zkKtUZ12JUjOohVwhWJ5o8N6SIwZxoO1OmgHhF5l21KRy48yH59ruxs30vv5O5PstOXuwmzotiVTQBQqN |
