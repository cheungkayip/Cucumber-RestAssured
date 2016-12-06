
Feature: JohanNeeskens_1Policy_FutureEnding

  Scenario: Authorize with user JohanNeeskens
    Given I want to login with user "JohanNeeskens"
    Then response should have status code "302"

  Scenario: Start a Car modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0801" and overeenkomstId "101010" and object "CAR111"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-car-insurance-replace-vehicle" endpoint
    Then response should have status code "200"
    And response should be:
    """
    Uw Alles in één Polis eindigt binnenkort. U kunt daarom geen wijzigingen meer doorvoeren. Neem contact op met uw Rabobank als u hier vragen over heeft.
    """


