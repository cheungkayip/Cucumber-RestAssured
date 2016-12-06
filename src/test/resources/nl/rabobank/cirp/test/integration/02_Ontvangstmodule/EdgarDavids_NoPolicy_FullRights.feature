
Feature: EdgarDavids_NoPolicy_FullRights

  Scenario: Authorize with user Edgar Davids
    Given I want to login with user "EdgarDavids"
    Then response should have status code "302"

  Scenario: Start Trailer with a new policy and new insurance flow
    Given I create a "NEW" flow and productCode "0806"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-trailer-insurance-license" endpoint
    Then response should have status code "200"
    And response should be:
    """
    {"licensePlateNumber":{"label":"Wat is het eigen kenteken van uw aanhangwagen?","value":null},"sameLicensePlateAsCar":{"label":"Heeft uw aanhangwagen hetzelfde kenteken als uw auto?","value":null,"options":[{"key":"true","value":"Ja"},{"key":"false","value":"Nee"}]},"chassisNumber":{"label":"Chassisnummer","value":null},"messages":{"0024":"Vul een geldig chassisnummer in. Dit kunt u vinden op uw kentekenbewijs.","0027":"Vul een geldig kenteken in."}}
    """


