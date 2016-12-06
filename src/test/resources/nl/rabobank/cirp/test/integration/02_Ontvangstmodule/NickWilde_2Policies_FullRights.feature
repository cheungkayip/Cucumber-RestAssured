Feature: NickWilde_2Policies_FullRights

  Scenario: Authorize with user NickWilde
    Given I set policy rights for user "NickWilde" with:
      | authorization     | policy |
      | GN_READ GN_CHANGE | 987654 |
      | GN_READ GN_CHANGE | 876543 |
    Given I want to login with user "NickWilde"
    Then response should have status code "302"

  Scenario: Open cirp
    Given With an Existing Policy I create a "NEW" flow and overeenkomstId "987654" and productCode "0806"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-trailer-insurance-license" endpoint
    Then response should have status code "200"
    And response should be:
    """
    {"licensePlateNumber":{"label":"Wat is het eigen kenteken van uw aanhangwagen?","value":null},"sameLicensePlateAsCar":{"label":"Heeft uw aanhangwagen hetzelfde kenteken als uw auto?","value":null,"options":[{"key":"true","value":"Ja"},{"key":"false","value":"Nee"}]},"chassisNumber":{"label":"Chassisnummer","value":null},"messages":{"0024":"Vul een geldig chassisnummer in. Dit kunt u vinden op uw kentekenbewijs.","0027":"Vul een geldig kenteken in."}}
    """


