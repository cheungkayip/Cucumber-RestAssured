package nl.cucumber.restassured;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import nl.cucumber.restassured.helper.JSONReader;
import org.apache.commons.collections4.ListUtils;

import java.net.MalformedURLException;
import java.util.List;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;


public class RestStepDefinitions extends Config {

    private Response response;
    private List<String> raceList;

    @Given("^I want to get all the Circuit names")
    public void getAllRacesIn2016() throws MalformedURLException {
        response = given().get("http://ergast.com/api/f1/2016.json").then().contentType(ContentType.JSON).extract().response();
        raceList = response.jsonPath().getList("MRData.RaceTable.Races.raceName");
        assertThat(raceList.size(), notNullValue());
    }

    @Then("^response should have status code \"([^\"]*)\"$")
    public void response_should_have_status_code(int statusCode) throws Throwable {
        response.then().statusCode(equalTo(statusCode));
    }

    @And("^I want to check all the circuit names are correct")
    public void checkIfAllRaceNamesAreCorrect() {
        JSONReader jr = new JSONReader();
        List<String> list = jr.readRacesFromFile("./src/test/resources/testdata/RacesSeason2016.json");
        List commonList = ListUtils.retainAll(list,raceList);
        assertEquals(commonList.size(),raceList.size());
    }

    @And("^that the total amount of races should be \"([^\"]*)\"$")
    public void checkTotalAmountOfRaces(int totalAmountOfRaces) {
        int raceCount = raceList.size();
        assertEquals(raceCount,totalAmountOfRaces);
    }

}
