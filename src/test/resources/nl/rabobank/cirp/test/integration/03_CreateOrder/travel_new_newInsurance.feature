@Integration
@CreateOrder
Feature: travel_new_newInsurance

  Scenario: Authorize with user Mike Wazowski
    Given I want to login with user "MikeWazowski"
    Then response should have status code "302"

  Scenario: Start travel with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0814"
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-travel-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basisAnswers trailer
    Given I compose "configure-travel-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"01-01-2017","houseHold":"01","travelDurationUninterrupted":"01","coverageAreaCodeFlag":"true","winterAndUnderwaterSportsFlag":"true","businessTravelFlag":"true","studentFlag":"false"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-travel-insurance-coverage" endpoint
    Then response should have status code "200"


  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-travel-insurance-premium-calculation" endpoint for payload:
    """
    {"cancellationTravelAmount":"1","luggageTravelAmount":"3000"}
    """
    Then response should have status code "200"


  Scenario: POST to selected coverage
    Given I compose "configure-travel-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["TravelPersonalAssistance","LuggageTravel","TravelCancellation","TravelMedical","BreakdownAssistanceVehicle"],"cancellationTravelAmount":"1","luggageTravelAmount":"3000"}
    """
    Then response should have status code "200"

  Scenario: GET Payment method load
    Given I compose "configure-payment-method-load" endpoint
    Then response should have status code "200"

  Scenario: POST Configure Payment method save
    Given I compose "configure-payment-method-save" endpoint for payload:
    """
    {"paymentOption":"MonthlyDirectDebit","paymentAccount":"NL94 RABO 0109 6785 91"}
    """
    Then response should have status code "200"

  Scenario: GET Closing questions for insurance
    Given I compose "configure-closing-questions-insurance-questions" endpoint
    Then response should have status code "200"

  Scenario: POST Closing questions answers
    Given I compose "configure-closing-questions-insurance-answers" endpoint for payload:
    """
    {"answers":["option_no","option_no"]}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000701 |

  Scenario: POST Summarize screen save and validate request of OpvoerenAanvraag
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "CreateOrder" should contain:
      | name                                | value           |
      | Applicant:RelationId                | 999990000000701 |
      | OrderLine:CommercialProductTypeCode | 0897            |
      | OrderLine:StatusCode                | In progress       |
      | ChannelCode                         | INT SEC         |
      | ActionCode                          | New             |
      | SubActionCode                       | New             |
