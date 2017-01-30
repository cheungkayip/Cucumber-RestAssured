package nl.cucumber.restassured;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)

@CucumberOptions(features = "src/test/resources/nl/cucumber/restassured/",
        tags = { "@RacesSeason2016"},
        plugin = {
        "pretty",
        "junit:target/results.xml",
        "html:target/cucumber"
        }
        )
public class CucumberRunner extends Config {

    @BeforeClass
    public static void setup() throws Exception {

    }

    @AfterClass
    public static void teardown() {

    }

}
