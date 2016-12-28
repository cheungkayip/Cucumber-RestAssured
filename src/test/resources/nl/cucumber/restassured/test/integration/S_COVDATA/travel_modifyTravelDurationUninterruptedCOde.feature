
# TravelDurationUninterruptedCode Change to 60 dagen
# Triggers 3 changeScenario's  because of TravelDurationUninterruptedCode is situated in 3 coverages (BreakdownAssistanceVehicle, TravelMedical & TravelPersonalAssistance)
@Integration
@ChangeScenario
Feature: travel_modifyTravelDurationUninterruptedCode

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Travel modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0814" and overeenkomstId "333333" and object ""
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-travel-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers Travel
    Given I compose "configure-travel-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"01-01-2017","houseHold":"01","travelDurationUninterrupted":"01","coverageAreaCodeFlag":"true","winterAndUnderwaterSportsFlag":"true","businessTravelFlag":"true","studentFlag":"true"}
    """
    Then response should have status code "200"

  Scenario: POST coverage endpoint
    Given I compose "configure-travel-insurance-coverage" endpoint for payload:
    """
    """
    Then response should have status code "200"

  Scenario: POST CalculateOrderPremium request
    Given I compose "configure-travel-insurance-premium-calculation" endpoint for payload:
    """
    {"cancellationTravelAmount":"3","luggageTravelAmount":"3000"}
    """
    Then response should have status code "200"
    And response should be:
    """
    {"LuggageTravel":{"amount":"13","paymentFrequency":"per jaar"},"TravelCancellation":{"amount":"18","paymentFrequency":"per jaar"},"BreakdownAssistanceVehicle":{"amount":"26","paymentFrequency":"per jaar"},"TravelMedical":{"amount":"13","paymentFrequency":"per jaar"},"TravelPersonalAssistance":{"amount":"24","paymentFrequency":"per jaar"}}
    """
    And XML "req" of "CalculateOrderPremium" should contain:
      | name       | value           |
      | RelationId | 999990000000204 |

  Scenario: GET coverage endpoint
    Given I compose "configure-travel-insurance-coverage" endpoint
    Then response should have status code "200"

# Verander hier je Travel coverage
  Scenario: POST coverage endpoint
    Given I compose "configure-travel-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["TravelPersonalAssistance","BreakdownAssistanceVehicle","TravelMedical"]}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name       | value           |
      | RelationId | 999990000000204 |

  Scenario: POST Summarize screen SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                 | value                                                                                                |
      | RelationId                                           | 999990000000204                                                                                      |
      | NVP:ChangeScenarioChangeScenarioCode1                | S_COVDATA                                                                                            |
      | NVP:ChangeScenarioSequenceNumber1                    | 1                                                                                                    |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001 | ZP_B_S_COVDATA_AMD                                                                                   |
      | NVP:ChangeScenarioChangeActionDate001001             | 01/01/2017                                                                                           |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001  | LongTermTravel-LongTermTravel_Cirp_1-Coverage-BreakdownAssistanceVehicle-1LongTermTravel-LongTermTra |
      | NVP:ChangeScenarioChangeScenarioCode2                | S_COVDATA                                                                                            |
      | NVP:ChangeScenarioSequenceNumber2                    | 2                                                                                                    |
      | NVP:ChangeScenarioChangeActionChangeActionCode002001 | ZP_B_S_COVDATA_AMD                                                                                   |
      | NVP:ChangeScenarioChangeActionDate002001             | 01/01/2017                                                                                           |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_002001  | LongTermTravel-LongTermTravel_Cirp_1-Coverage-TravelPersonalAssistance-1LongTermTravel-LongTermTrave |
      | NVP:ChangeScenarioChangeScenarioCode3                | S_COVDATA                                                                                            |
      | NVP:ChangeScenarioSequenceNumber3                    | 3                                                                                                    |
      | NVP:ChangeScenarioChangeActionChangeActionCode003001 | ZP_B_S_COVDATA_AMD                                                                                   |
      | NVP:ChangeScenarioChangeActionDate003001             | 01/01/2017                                                                                           |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_003001  | LongTermTravel-LongTermTravel_Cirp_1-Coverage-TravelMedical-1LongTermTravel-LongTermTravel_Cirp_1-Co |
      | NVP:ChangeScenarioChangeScenarioCode4                | null                                                                                                 |