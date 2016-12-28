package nl.cucumber.restassured.test.integration;

import com.jayway.restassured.RestAssured;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)

@CucumberOptions(features = "src/test/resources/nl/cucumber/restassured/test/integration/", tags = { "@Integration" }, plugin = {
        "pretty",
        "junit:target/results.xml",
        "html:target/cucumber"})
public class IntegrationTest extends Config {

    @BeforeClass
    public static void setup() throws Exception {
        loadConfig();
        // set logging to true on application server
        RestAssured.given().get(stubserver + "/pifcirp-stub/ws/bla?log=true");

    }

    @AfterClass
    public static void teardown() {
        // set logging to false
        RestAssured.given().get(stubserver + "/pifcirp-stub/ws/bla?log=false");
    }

}
