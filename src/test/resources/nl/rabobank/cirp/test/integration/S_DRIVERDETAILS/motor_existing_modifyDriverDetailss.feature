# CIRP PIPELINE TESTS: http://lsrv4770.linux.rabobank.nl:8080/jenkins/job/mcv_pifcirp_test_rest_integration/

@Integration
@ChangeScenario
@S_DRIVERDETAILS
Feature: motor_existing_modifyDriverDetails

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Motor modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0802" and overeenkomstId "333333" and object "MT1111"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-motor-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers motor with licencePlate
    Given I compose "configure-motor-insurance-licenseAnswers" endpoint for payload:
    """
    {"licensePlate":"MT1111","sideCar":"9010401","motorId":"0"}
    """
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-motor-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers motor
    Given I compose "configure-motor-insurance-basicAnswers" endpoint for payload:
    """
    {"driverAnswers":{"regularDriverCode":"0002","birthDate":"13-05-1995","initials":"K.I.N","genderCode":"1","surname":"Geel","relationToDriver":"0002"},"claimFreeYears":"10","startDate":"dateChange","winterReduction":"true"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-motor-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-motor-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: POST selected-coverage endpoint
    Given I compose "configure-motor-insurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"LiabilityCasco"}
    """
    Then response should have status code "200"

  Scenario: GET additional endpoint
    Given I compose "configure-motor-insurance-additional" endpoint
    Then response should have status code "200"


  Scenario: POST selected-additional endpoint
    Given I compose "configure-motor-insurance-save-model" endpoint for payload:
    """
    {"additionalCoverages":["PassengerInjuries","NoClaimProtection","RoadAssistanceNetherlands","RoadAssistanceAbroad"]}
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
      | name       | value           |
      | RelationId | 999990000000204 |

  Scenario: POST Summarize screen save and validate request of SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value                                                    |
      | RelationId                                           | 999990000000204                                          |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_DRIVERDETAILS                                          |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                                                        |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | ZP_B_S_DRIV_AMD                                          |
      | NVP:ChangeScenarioChangeActionDate001001             | dateChange                                               |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | InsuredObject_Motor_Cirp_1_1InsuredObject_Motor_Cirp_1_2 |
      | NVP:ChangeScenarioChangeScenarioCode2                | S_DRIVERDETAILS                                          |
      | NVP:ChangeScenarioSequenceNumber2                    | 2                                                        |
      | NVP:ChangeScenarioChangeActionChangeActionCode002001 | ZP_B_S_DRIV_AMD                                          |
      | NVP:ChangeScenarioChangeActionDate002001             | dateChange                                               |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_002001  | InsuredObject_Motor_Cirp_1_1InsuredObject_Motor_Cirp_1_2 |
      | NVP:ChangeScenarioChangeScenarioCode3                | null                                                     |
