package nl.cucumber.restassured.test.integration;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)

@CucumberOptions(features = "src/test/resources/nl/cucumber/restassured/test/integration/",
        tags = { "@RacesSeason2016"},
        plugin = {
        "pretty",
        "junit:target/results.xml",
        "html:target/cucumber"
        }
        )
public class ErgastServiceCucumberRunner extends Config {

    @BeforeClass
    public static void setup() throws Exception {

    }

    @AfterClass
    public static void teardown() {

    }

}
