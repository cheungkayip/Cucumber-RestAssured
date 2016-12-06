@Integration
@CreateOrder
Feature: accidents_new_newInsurance

  Scenario: Authorize with user Mike Wazowski
    Given I want to login with user "MikeWazowski"
    Then response should have status code "302"

  Scenario: Start Accidents with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0812"
    Then response should have status code "200"

  Scenario: GET Basic endpoint
    Given I compose "configure-accident-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST Answers basic endpoint
    Given I compose "configure-accident-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"dateChange","houseHold":"01"}
    """
    Then response should have status code "200"

  Scenario: GET Cash receipt
    Given I compose "cash-receipt" endpoint
    Then response should have status code "200"
    And response should be:
    """
    {"cashReceipt":{"summary":{"paymentFrequency":"per maand","subtotal":"Subtotaal","title":"Interpolis Alles in één Polis®","yourNewPremium":"Uw premie wordt"},"configuringInsurance":{"label":"Ongevallenverzekering","basicCoverages":[{"label":"Ongevallenverzekering","name":"PersonalAccidents","premium":"17,00","selected":true,"additionalCoverages":[]}]},"otherInsurances":[]}}
    """

  Scenario: POST Calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-accident-insurance-premium-calculation" endpoint for payload:
    """
    {"personalAccidentsInsuranceAmount":"06"}
    """
    Then response should have status code "200"
    And response should be:
    """
    {"PersonalAccidents":{"amount":"17","paymentFrequency":"per maand"}}
    """
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                     | value           |
      | RelationId               | 999990000000701 |
      | NVP:InsuredAmountCode    | 06 |

  Scenario: POST Selected coverage
    Given I compose "configure-accident-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["PersonalAccidents"],"insuredAmount":"06"}
    """
    Then response should have status code "200"

  Scenario: GET Payment method load
    Given I compose "configure-payment-method-load" endpoint
    Then response should have status code "200"

  Scenario: GET Closing questions for insurance
    Given I compose "configure-closing-questions-insurance-questions" endpoint
    Then response should have status code "200"

  Scenario: POST Configure Payment method save
    Given I compose "configure-payment-method-save" endpoint for payload:
    """
    {"paymentOption":"MonthlyDirectDebit","paymentAccount":"NL39 RABO 0300 0652 64"}
    """
    Then response should have status code "200"

  Scenario: POST Closing questions answers
    Given I compose "configure-closing-questions-insurance-answers" endpoint for payload:
    """
    {"answers":["value.boolean.false","value.boolean.false"]}
    """
    Then response should have status code "200"

  Scenario: GET Summarize screen open and validate request of ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name       | value           |
      | RelationId | 999990000000701 |

  Scenario: POST Summarize screen save and validate request of CreateOrder
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "CreateOrder" should contain:
      | name                                | value     |
      | Applicant:RelationId                | 999990000000701 |
      | OrderLine:CommercialProductTypeCode | 0897      |
      | OrderLine:StatusCode                | In progress |
      | ChannelCode                         | INT SEC   |
      | ActionCode                          | New       |
      | SubActionCode                       | New       |

