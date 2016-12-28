@Integration
@CreateOrder
Feature: trailer_new_newInsurance

  Scenario: Authorize with user Mike Wazowski
    Given I want to login with user "MikeWazowski"
    Then response should have status code "302"

  Scenario: Start Trailer with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0806"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-trailer-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: POST licenseAnswers trailer with licencePlate
    Given I compose "configure-trailer-insurance-licenseAnswers" endpoint for payload:
    """
    {"sameLicensePlateAsCar":"false","licensePlate":"wa1111","chassisNumber":null}
    """
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-trailer-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basisAnswers trailer
    Given I compose "configure-trailer-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"12-12-2016","yearOfConstruction":"2000","yearOfAcquisition":"2001","acquisitionCost":"2000","owner":"true"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-trailer-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-trailer-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000701 |
      | NVP:ChassisNumber                   | null            |
      | NVP:RegistrationNumber              | wa1111          |
      | NVP:YearOfManufacture               | 2000            |
      | NVP:YearOfPurchase                  | 2001            |
      | NVP:OwnerToPolicyHolderRelationCode | 001             |
      | NVP:PurchaseValueAmount             | 2000            |
      | NVP:MaximumWeightInKilos            | 3500            |

  Scenario: POST to selected coverage
    Given I compose "configure-trailer-insurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"Casco"}
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
