package nl.cucumber.restassured;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.hamcrest.Matchers;

import java.net.MalformedURLException;
import java.util.HashMap;

import static io.restassured.RestAssured.given;
import static org.junit.Assert.assertEquals;


public class RestStepDefinitions extends Config {

    private Response response;
    private static String jsonAsString;

    @Given("^I want to get all the Circuit names")
    public void getAllRacesIn2016() throws MalformedURLException {
        response = given().when().get("http://ergast.com/api/f1/2016.json").then().contentType(ContentType.JSON).extract().response();
        jsonAsString = response.asString();
    }

    @Then("^response should have status code \"([^\"]*)\"$")
    public void response_should_have_status_code(int statusCode) throws Throwable {
        response.then().statusCode(Matchers.equalTo(statusCode));
    }

    @And("^I want to check all the circuit names are correct")
    public void checkIfAllRaceNamesAreCorrect() {
//        HashMap<String, ?> rideStates = response.jsonPath("raceName");
//
//        int number = Integer.parseInt((String) grandTotalRaces);

    }

    @And("^that the total amount of races should be \"([^\"]*)\"$")
    public void checkTotalAmountOfRaces(int totalAmountOfRaces) {
        HashMap<String, ?> rideStates = response.path("MRData");
        Object grandTotalRaces = rideStates.get("total");
        int number = Integer.parseInt((String) grandTotalRaces);
        assertEquals(number,totalAmountOfRaces);
    }

}
