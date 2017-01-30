# Test for get/queryAbzAddressInformation info on OpvoerenAanvraag

@queryAbzAddress
Feature: home_new_newInsurance

  Scenario: Authorize with user Mike Wazowski
    Given I want to login with user "MikeWazowski"
    Then response should have status code "302"

  Scenario: Start Home with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0809"
    Then response should have status code "200"

  Scenario: GET address endpoint
    Given I compose "damage-insurance-aiep-address-address" endpoint
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-home-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST postalCode + houseNumber resolver
    Given I compose "damage-insurance-aiep-address-addressResolver" endpoint for payload:
    """
    {"postalCode":"2222AA","houseNumber":"2"}
    """
    Then response should have status code "200"

  Scenario: POST postalCode + houseNumber selected
    Given I compose "damage-insurance-aiep-address-addressSelected" endpoint for payload:
    """
    {"postalCode":"2222AA","houseNumber":"2","multipleAddressIndex":"2"}
    """
    Then response should have status code "200"

  Scenario: POST addressAnswers
    Given I compose "damage-insurance-aiep-address-addressAnswers" endpoint for payload:
    """
    {"postalCode":"2222AA","houseNumber":"2","buildingType":"9020104","roofType":"05","multipleAddressIndex":"2"}
    """
    Then response should have status code "200"


  Scenario: POST basisAnswers home
    Given I compose "configure-home-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"10-10-2016","houseHold":"01"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-home-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-home-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"
    And response should be:
    """
    {"premiums":{"Home":{"amount":"4","paymentFrequency":"per maand"}}}
    """
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000701 |
      | NVP:AbzAddressHouseNumber           | 2               |
      | NVP:AbzAddressHouseNumberExtension  | C               |
      | NVP:AbzAddressPostalCode            | 2222AA          |

  Scenario: POST to selected coverage
    Given I compose "configure-home-insurance-selected-coverage" endpoint for payload:
    """
    {"selectedCoverages":["Home"],"ownRiskType":"0"}
    """
    Then response should have status code "200"

  Scenario: GET House usage
    Given I compose "configure-home-insurance-home0x1use" endpoint
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
      | name                                | value           |
      | RelationId                          | 999990000000701 |

  Scenario: POST Summarize screen save and validate request of OpvoerenAanvraag
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "CreateOrder" should contain:
      | name                                | value           |
      | Applicant:RelationId                | 999990000000701 |
      | OrderLine:CommercialProductTypeCode | 0897            |
      | OrderLine:StatusCode                | Validated       |
      | ChannelCode                         | INT SEC         |
      | ActionCode                          | New             |
      | SubActionCode                       | New             |
      | AbzHousingProfileIdentificationResidence| ResidenceId               |
      | CustomerWozValueAmount                  | 222000                    |

