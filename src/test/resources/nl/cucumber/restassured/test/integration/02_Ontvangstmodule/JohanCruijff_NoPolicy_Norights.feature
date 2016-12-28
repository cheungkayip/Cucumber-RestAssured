Feature: JohanCruijff_NoPolicy_Norights

  Scenario: Authorize with user Johan Cruijff
    Given I want to login with user "JohanCruijff"
    Then response should have status code "302"

  Scenario: Start Trailer with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0806"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-trailer-insurance-license" endpoint
    Then response should have status code "200"
    And response should be:
    """
    U kunt de Interpolis Alles in één Polis® helaas niet afsluiten. Neem contact op met uw Rabobank als u hier vragen over heeft.
    """


