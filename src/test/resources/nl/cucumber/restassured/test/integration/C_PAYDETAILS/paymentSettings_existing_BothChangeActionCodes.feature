# TESTCASE LUGGAGE 0815 EXISTING Policy MODIFY PaymentSettings Simulating the GET and POST actions that happens through the application
# ChangeScenarioChangeActionChangeActionCode = 'P_B_S_PPY_AMD' AND 'P_B_S_PMD_AMD'
@Inactive
Feature: paymentSettings_existing_BothChangeActionCodes

  Scenario: Authorize with user MarkGeel
    Given I want to login with user "MarkGeel"
    Then response should have status code "302"

  Scenario: Start a Luggage modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0815" and overeenkomstId "333333" and object ""
    Then response should have status code "200"

  Scenario: GET basic answers endpoint
    Given I compose "configure-luggage-insurance-basic" endpoint
    Then response should have status code "200"

  Scenario: POST basicAnswers
    Given I compose "configure-luggage-insurance-basicAnswers" endpoint for payload:
    """
    {"startDate":"01-01-2017","houseHold":"01"}
    """
    Then response should have status code "200"

  Scenario: GET coverage endpoint
    Given I compose "configure-luggage-insurance-coverage" endpoint
    Then response should have status code "200"

  Scenario: POST to calculate premium and validate expected values are set in CalculateOrderPremium request
    Given I compose "configure-luggage-insurance-premium-calculation" endpoint for payload:
    """
    {"continuousCoverageAmount":"70000"}
    """
    Then response should have status code "200"
    And response should be:
    """
    {"LuggageContinuous":{"amount":"17","paymentFrequency":"per jaar"}}
    """
    And XML "req" of "CalculateOrderPremium" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000204 |

  Scenario: POST coverage endpoint
    Given I compose "configure-luggage-insurance-selected-coverage" endpoint for payload:
    """
    {"continuousCoverageAmount":"70000","selectedCoverages":["LuggageContinuous"]}
    """
    Then response should have status code "200"

  Scenario: GET payment methods answers endpoint
    Given I compose "configure-payment-method-load" endpoint
    Then response should have status code "200"

  Scenario: GET closing questions answers endpoint
    Given I compose "configure-closing-questions-insurance-questions" endpoint
    Then response should have status code "200"

#Change paymentMethod
  Scenario: POST payment settings request
    Given I compose "configure-payment-method-save" endpoint for payload:
    """
    {"paymentOption":"MonthlyDirectDebit","paymentAccount":"NL39 RABO 0300 0652 64"}
    """
    Then response should have status code "200"

  Scenario: POST closing questions answers request
    Given I compose "configure-closing-questions-insurance-answers" endpoint for payload:
    """
    {"answers":["option_no","option_no"]}
    """
    Then response should have status code "200"


  Scenario: GET Summarize screen ValidateOrderByProducer
    Given I compose "summarize-order-insurance-aiep-open" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "ValidateOrderByProducer" should contain:
      | name                                | value           |
      | RelationId                          | 999990000000204 |

  Scenario: POST Summarize screen SaveOrderStartBpm
    Given I compose "summarize-order-insurance-aiep-save" endpoint for payload:
    """
    """
    Then response should have status code "200"
    And XML "req" of "SaveOrderStartBpm" should contain:
      | name                                                     | value                      |
      | RelationId                                               | 999990000000204            |
      | NVP:ChangeScenarioChangeScenarioCode1                    | C_PAYDETAILS               |
      | NVP:ChangeScenarioSequenceNumber1                        | 1                          |
      | NVP:ChangeScenarioChangeActionChangeActionCode001001     | P_B_S_PPY_AMD              |
      #ActionDate= The date of today
      | NVP:ChangeScenarioChangeActionDate001001                 | dateToday                 |
      | NVP:ChangeScenarioChangeActionReferenceUID_1_001001      | POL-999990000000204-PREMIUMPAYER-01POL-999990000000204-PREMIUMPAYER-02 |
      | NVP:ChangeScenarioChangeActionChangeActionCode001002     | P_B_S_PMD_AMD              |
      | NVP:ChangeScenarioChangeActionDate001002                 | dateToday              |
      #| NVP:ChangeScenarioChangeActionReferenceUID_1_001002      | tR9HK3AGFp2L3pUZ4pmX7XDDvo7X96HryMoDLj2UUlxUz5vOUPXElD3PB0vBiDQs5SZrUBWtN4PSBSRJFtRqJs3X55FYKLl6EDOZ | bug
      | NVP:ChangeScenarioChangeScenarioCode2                    | null                |
