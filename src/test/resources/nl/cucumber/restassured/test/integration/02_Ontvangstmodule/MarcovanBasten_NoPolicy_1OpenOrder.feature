
Feature: MarcovanBasten_NoPolicy_1OpenOrder

  Scenario: Authorize with user MarcovanBasten
    Given I want to login with user "MarcovanBasten"
    Then response should have status code "302"

  Scenario: Start Trailer with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0802"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-motor-insurance-license" endpoint
    Then response should have status code "200"
    And response should be:
    """
    Er staat een aanvraag voor u klaar om te ondertekenen. U moet deze aanvraag eerst ondertekenen of verwijderen voordat u een nieuwe aanvraag kunt doen.  Kies daarvoor 'Naar bevestigen’.
    """


