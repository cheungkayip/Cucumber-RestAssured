# TESTCASE CAR 0801 Change Insured Object http://jira.rabobank.nl/secure/RapidBoard.jspa?rapidView=1434&view=detail&selectedIssue=VKVMINION-1248
@ChangeScenario
@S_SUBJECT
Feature: car_existing_modifyInsuredObject

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Car modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0801" and overeenkomstId "333333" and object "CR1111"
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-car-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers car
    Given I compose "configure-car-insurance-basicAnswers" endpoint for payload:
    """
    {"driverAnswers":{"regularDriverCode":"0001","birthDate":"13-05-1995","initials":"M.I.N","genderCode":"1","surname":"Geel","relationToDriver":"0003"},"useOfCar":"Privé","claimFreeYears":"10","startDate":"dateChange"}
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
      | RelationId                                           | 999990000000204 |

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value           |
      | RelationId                                           | 999990000000204 |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_SUBJECT       |
      | NVP:ChangeScenarioSequenceNumber1                    | 1               |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | P_B_S_SBJ_AMD   |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange      |
      | NVP:ChangeScenarioChangeScenarioCode2                | null            |
