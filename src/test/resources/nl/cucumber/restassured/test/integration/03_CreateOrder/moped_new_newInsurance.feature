@Integration
@CreateOrder
Feature: moped_new_newInsurance

  Scenario: Authorize with user Mike Wazowski
    Given I want to login with user "MikeWazowski"
    Then response should have status code "302"

  Scenario: Start Moped with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0803"
    Then response should have status code "200"

  Scenario: GET Moped license plate endpoint
    Given I compose "configure-moped-insurance-license" endpoint
    Then response should have status code "200"

  Scenario: GET Basic answers endpoint
    Given I compose "configure-moped-insurance-basic" endpoint
    Then response should have status code "200"


  Scenario: POST LicenseAnswers moped with licensePlate
    Given I compose "configure-moped-insurance-licenseAnswers" endpoint for payload:
    """
    {"licensePlate":"MP1111","mopedId":"0"}
    """
    Then response should have status code "200"


  Scenario: POST BasisAnswers moped
    Given I compose "configure-moped-insurance-basicAnswers" endpoint for payload:
    """
    {"driverAnswers":{"regularDriverCode":"0001","birthDate":null,"initials":null,"genderCode":null,"surname":null,"relationToDriver":null},"startDate":"dateChange"}
    """
    Then response should have status code "200"

  Scenario: GET Coverage endpoint
    Given I compose "configure-moped-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: GET Cash receipt
    Given I compose "cash-receipt" endpoint
    Then response should have status code "200"
    And response should be:
    """
    {"cashReceipt":{"summary":{"paymentFrequency":"per maand","subtotal":"Subtotaal","title":"Interpolis Alles in één Polis®","yourNewPremium":"Uw premie wordt"},"configuringInsurance":{"label":"Bromfietsverzekering","basicCoverages":[{"label":"WA","name":"Liability","premium":"2,01","selected":false,"additionalCoverages":[{"label":"Voertuighulp Nederland","name":"RoadAssistanceNetherlands","premium":"7,01","selected":false,"additionalCoverages":[]},{"label":"Voertuighulp Buitenland","name":"RoadAssistanceAbroad","premium":"8,01","selected":false,"additionalCoverages":[]}]},{"label":"WA + Beperkt Casco","name":"LiabilityCascoLimited","premium":"4,01","selected":false,"additionalCoverages":[{"label":"Voertuighulp Nederland","name":"RoadAssistanceNetherlands","premium":"7,01","selected":false,"additionalCoverages":[]},{"label":"Voertuighulp Buitenland","name":"RoadAssistanceAbroad","premium":"8,01","selected":false,"additionalCoverages":[]}]},{"label":"WA + Volledig Casco","name":"LiabilityCasco","premium":"3,01","selected":false,"additionalCoverages":[{"label":"Voertuighulp Nederland","name":"RoadAssistanceNetherlands","premium":"7,01","selected":false,"additionalCoverages":[]},{"label":"Voertuighulp Buitenland","name":"RoadAssistanceAbroad","premium":"8,01","selected":false,"additionalCoverages":[]}]}]},"otherInsurances":[]}}
    """

  Scenario: POST Calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-moped-insurance-premium-calculation" endpoint for payload:
    """
    {"ownRiskType":"0"}
    """
    Then response should have status code "200"
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                   | value           |
      | RelationId             | 999990000000701 |
      | NVP:RegistrationNumber | MP1111          |

  Scenario: POST Selected coverage
    Given I compose "configure-moped-insurance-selected-coverage" endpoint for payload:
    """
    {"ownRiskType":"0","coverage":"Liability"}
    """
    Then response should have status code "200"


  Scenario: POST Additional coverages
    Given I compose "configure-moped-insurance-selected-additional" endpoint for payload:
    """
    {"additionalCoverages":["RoadAssistanceNetherlands"]}
    """
    Then response should have status code "200"

  Scenario: GET Checkcode view
    Given I compose "common-checkcode-view" endpoint
    Then response should have status code "200"

  Scenario: GET Payment method load
    Given I compose "configure-payment-method-load" endpoint
    Then response should have status code "200"

  Scenario: GET Closing questions for insurance
    Given I compose "configure-closing-questions-insurance-questions" endpoint
    Then response should have status code "200"

  Scenario: POST Checkcode answer
    Given I compose "common-checkcode-answers" endpoint for payload:
    """
    {"checkCode":"0123"}
    """
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


