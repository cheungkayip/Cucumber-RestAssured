# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/
# http://jira.rabobank.nl/browse/VKVMINION-1240
# TESTCASE MOPED 0803 EXISTING Policy MODIFY Insurance ADD ADDITIONAL ROAD ASSISTANCE Simulating the GET and POST actions that happens through the application
@Integration
@ChangeScenario
Feature: moped_existing_modifyAddRoadAssistanceNL

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Moped modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0803" and overeenkomstId "333333" and object "MP1111"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-moped-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers moped with licencePlate
    Given I compose "configure-moped-insurance-licenseAnswers" endpoint for payload:
    """
    {"licensePlate":"MP1111","mopedId":"0"}
    """
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-moped-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers moped
    Given I compose "configure-moped-insurance-basicAnswers" endpoint for payload:
    """
    {"driverAnswers":{"regularDriverCode":"0001","birthDate":"13-05-1995","initials":"M.I.N","genderCode":"1","surname":"Geel","relationToDriver":"0001"},"startDate":"dateChange"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-moped-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-moped-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: POST coverage endpoint
    Given I compose "configure-moped-insurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"LiabilityCasco"}
    """
    Then response should have status code "200"

  Scenario: POST additional endpoint
    Given I compose "configure-moped-insurance-selected-additional" endpoint for payload:
    """
    {"additionalCoverages":["RoadAssistanceAbroad","RoadAssistanceNetherlands"]}
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


  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                     | value                      |
      | RelationId                                               | 999990000000204            |
      | NVP:ChangeScenarioChangeScenarioCode1                    | S_ADDCOVPAC                |
      | NVP:ChangeScenarioSequenceNumber1                        | 1                          |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001     | P_B_S_BTX_COVPAC           |
      | NVP:ChangeScenarioChangeActionDate001001                 | dateChange                 |
      | NVP:ChangeScenarioChangeScenarioCode2                    | null            |