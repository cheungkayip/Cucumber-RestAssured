
Feature: RuudGullit_1Policy_1OpenOrder

  Scenario: Authorize with user RuudGullit
    Given I want to login with user "RuudGullit"
    Then response should have status code "302"

  Scenario: Start a Car modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0801" and overeenkomstId "101988" and object "CAR111"
    Then response should have status code "200"

  Scenario: GET why to change questions endpoint
    Given I compose "configure-car-insurance-replace-vehicle" endpoint
    Then response should have status code "200"
    And response should be:
    """
    U heeft een aanvraag gedaan die in behandeling is bij Interpolis. U ontvangt hierover binnen 5 werkdagen een bericht. In de tussentijd kunt u uw polis niet wijzigen.
    """
