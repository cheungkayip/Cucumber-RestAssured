package nl.cucumber.restassured.test.integration;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.junit.BeforeClass;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Map;

import static io.restassured.RestAssured.when;
import static io.restassured.path.json.JsonPath.from;
import static org.hamcrest.core.IsEqual.equalTo;
import static org.junit.Assert.assertThat;

public class RestStepDefinitions extends Config {

    private Response response;

    private static String jsonAsString;

    @BeforeClass
    public static void setupURL()
    {
        // here we setup the default URL and API base path to use throughout the tests
        RestAssured.baseURI = "http://ergast.com";
        RestAssured.basePath = "/api/";
    }

    @Given("^I want to get all the Circuit names")
    public void getAllRacesIn2016() throws MalformedURLException {
        response = when().get("f1/2016.json").then().contentType(ContentType.JSON).extract().response();
        jsonAsString = response.asString();
    }

    @And("^I want to check all the circuit names are correct")
    public void checkIfAllRaceNamesAreCorrect(){

    }

    @And("^that the total amount of races should be \"([^\"]*)\"$")
    public void checkTotalAmountOfRaces(){
        // first we put our 'jsonAsString' into an ArrayList of Maps of type <String, ?>
        ArrayList<Map<String,?>> jsonAsArrayList = from(jsonAsString).get("");
        // now we count the number of entries in the JSON file, each entry is 1 ride
        assertThat(jsonAsArrayList.size(), equalTo(21));
    }

}
