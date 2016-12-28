
Feature: DennisBergkamp_1Policy_FunctBlock

  Scenario: Authorize with user DennisBergkamp
    Given I want to login with user "DennisBergkamp"
    Then response should have status code "302"

  Scenario: Start a Car modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0801" and overeenkomstId "101010" and object "CAR111"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-car-insurance-replace-vehicle" endpoint
    Then response should have status code "200"
    And response should be:
    """
    U kunt deze verzekering niet wijzigen omdat deze in behandeling is. Hebt u in de tussentijd vragen? Belt u ons dan.
    """


