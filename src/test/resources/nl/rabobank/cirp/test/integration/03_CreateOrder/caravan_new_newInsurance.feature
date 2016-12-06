@Integration
@CreateOrder
Feature: caravan_new_newInsurance

  Scenario: Authorize with user Mike Wazowski
    Given I want to login with user "MikeWazowski"
    Then response should have status code "302"

  Scenario: Start Caravan with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0813"
    Then response should have status code "200"

  Scenario: GET Caravan license plate endpoint
    Given I compose "configureproduct-insurance-caravaninsurance-license" endpoint
    Then response should have status code "200"

  Scenario: GET Basic answers endpoint
    Given I compose "configureproduct-insurance-caravaninsurance-basic" endpoint
    Then response should have status code "200"


  Scenario: POST LicenseAnswers caravan with licensePlate
    Given I compose "configureproduct-insurance-caravaninsurance-licenseAnswers" endpoint for payload:
    """
    {"sameLicensePlateAsCar":"false","licensePlate":"WA-11-11","chassisNumber":null,"caravanType":"9010201","brand":"0074","yearOfConstruction":"2016","hailResistanceRoof":"true"}
    """
    Then response should have status code "200"


  Scenario: POST BasisAnswers caravan
    Given I compose "configureproduct-insurance-caravaninsurance-basicAnswers" endpoint for payload:
    """
    {"yearOfAcquisition":"2016","acquisitionCost":"45555","inventoryValue":"04","startDate":"dateChange"}
    """
    Then response should have status code "200"

  Scenario: GET Cash receipt
    Given I compose "cash-receipt" endpoint
    Then response should have status code "200"
    And response should be:
    """
    {"cashReceipt":{"summary":{"paymentFrequency":"per maand","subtotal":"Subtotaal","title":"Interpolis Alles in één Polis®","yourNewPremium":"Uw premie wordt"},"configuringInsurance":{"label":"Caravanverzekering","basicCoverages":[{"label":"Beperkt casco","name":"CascoLimited","premium":"9,01","selected":false,"additionalCoverages":[]},{"label":"Volledig Casco","name":"Casco","premium":"11,01","selected":false,"additionalCoverages":[]}]},"otherInsurances":[]}}
    """

  Scenario: GET Coverage endpoint
    Given I compose "configureproduct-insurance-caravaninsurance-coverage" endpoint
    Then response should have status code "200"


  Scenario: POST Calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configureproduct-insurance-caravaninsurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                             | value           |
      | RelationId                       | 999990000000701 |
      | NVP:VehicleMakeDescription       | 3DOG          |

  Scenario: POST Selected coverage
    Given I compose "configureproduct-insurance-caravaninsurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"Casco"}
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
    {"paymentOption":"MonthlyDirectDebit","paymentAccount":"NL94 RABO 0109 6785 91"}
    """
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
      | name       | value           |
      | RelationId | 999990000000701 |

  Scenario: POST Summarize screen save and validate request of CreateOrder
    Given I compose "summarize-order-insurance-aiep-save" endpoint
    Then response should have status code "200"
    And XML "req" of "CreateOrder" should contain:
      | name                      | value     |
      | CommercialProductTypeCode | 0897      |
      | OrderLine:StatusCode      | In progress |
      | ChannelCode               | INT SEC   |
      | ActionCode                | New       |
      | SubActionCode             | New       |


