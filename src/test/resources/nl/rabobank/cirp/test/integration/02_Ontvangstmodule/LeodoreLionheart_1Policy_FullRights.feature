
Feature: LeodoreLionheart_1Policy_FullRights

  Scenario: Authorize with user LeodoreLionheart
    Given I want to login with user "LeodoreLionheart"
    Then response should have status code "302"

  Scenario: Start a Car modify flow
    Given I start a flowType "MODIFY" flow and productTypeCode "0801" and overeenkomstId "444999" and object "CAR111"
    Then response should have status code "200"

  Scenario: GET license plate endpoint
    Given I compose "configure-car-insurance-replace-vehicle" endpoint
    Then response should have status code "200"
    And response should be:
    """
    {"situation":{"label":"Wat wilt u doen?","value":null,"message":null,"tooltip":null,"disabled":null,"options":[{"key":"1","value":"Dekking of bestuurder wijzigen","notification":null,"message":""},{"key":"2","value":"Deze auto vervangen door een andere auto. U hebt de auto's maximaal 10 dagen tegelijk of u heeft maximaal 10 dagen geen auto","notification":null,"message":"U hebt een andere auto. Deze wijziging kan nog niet online. Belt u alstublieft uw Rabobank om ervoor te zorgen dat uw schadevrije jaren behouden blijven."},{"key":"3","value":"Een extra auto verzekeren","notification":null,"message":"U wilt een extra autoverzekering aanvragen. Voor deze autoverzekering krijgt u dezelfde no-claim korting als voor de eerste auto."}],"required":true,"requiredMessage":"Maak een keuze."}}
    """


