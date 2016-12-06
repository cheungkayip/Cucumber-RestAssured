Feature: NickWilde_2Policies_NoRights

  Scenario: Authorize with user
    Given I set policy rights for user "NickWilde" with:
      | authorization | policy |
      | GN_READ       | 987654 |
      | GN_READ       | 876543 |
    Given I want to login with user "NickWilde"
    Then response should have status code "302"

  Scenario: Open CIRP and validate no rights
    Given With an Existing Policy I create a "NEW" flow and overeenkomstId "987654" and productCode "0806"
    Then response should have status code "200"
    And response should contain:
    """
    U kunt uw Interpolis Alles in één Polis®  helaas niet online inzien.  Neem contact op met uw Rabobank als u hier vragen over heeft.
    """
