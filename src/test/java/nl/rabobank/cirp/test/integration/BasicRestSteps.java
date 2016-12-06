package nl.rabobank.cirp.test.integration;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.response.Cookie;
import com.jayway.restassured.response.Response;
import cucumber.api.Scenario;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import nl.rabobank.cirp.test.integration.helper.CookieUtil;
import nl.rabobank.cirp.test.integration.helper.LogfileSearch;
import nl.rabobank.cirp.test.integration.helper.TestDataLoader;
import nl.rabobank.cirp.test.integration.helper.XmlUtil;
import nl.rabobank.pif.support.log.PifLogSearch;
import nl.rabobank.pif.support.log.client.PicomaClient;
import org.hamcrest.Matchers;
import org.joda.time.DateTime;
import org.junit.Assert;

import java.net.URLEncoder;
import java.util.Date;
import java.util.List;

/**
 * Created by dietenjjb on 23-11-2015.
 */
public class BasicRestSteps extends Config {

    private Scenario scenario;

    private static String flowUrl;

    private String changeDate;
    private String changeDatePost;

    public String authCookie = "";

    private static String overeenkomstId;

    private Response response;

    @Before
    public void before(Scenario scenario) {
        this.scenario = scenario;
        changeDatePost = XmlUtil.dateToPostString(new DateTime(new Date()).plusYears(1).toDate());
        changeDate = XmlUtil.dateToString(new DateTime(new Date()).plusYears(1).toDate());
    }

    @Given("^I set policy rights for user \"([^\"]*)\" with:$")
    public void i_set_policy_rights_for_user_with(String user, List<Authorization> auths) throws Throwable {
        TestDataLoader testDataLoader = new TestDataLoader();
        testDataLoader.adjustKAD(user, auths);
    }

    @Given("^I want to login with user \"([^\"]*)\"$")
    public void i_want_to_login_with_user(String userName) throws Throwable {
        loadConfig();
        // initiate cookie to default
        CookieUtil.setCookie("default");
        String url = appserver + "/sam/handleCustomerKeyLogin.htm";
        String body =
                "type=customer&verifiedDebitCardBban=&verifiedDebitCardCardNumber=&registeredKey=&securityLevel=3&customerKey="
                        + userName + "&siebelCustomerId=&siteContextPath=" + URLEncoder.encode(context, "UTF-8")
                        + "&url=%2Foverview_aiep.html&login=";
        response = performPost(url, "application/x-www-form-urlencoded", body);
        authcookie_should_be_stored();
    }

    @Given("^I open policy overview with overeenkomstId \"([^\"]*)\"$")
    public void i_open_policy_overview_with_overeenkomstId(String overeenkomstId) throws Throwable {
        this.overeenkomstId = overeenkomstId;
        String url = appserver + context + virpContext + "?OvereenkomstId=" + overeenkomstId;
        performGet(url);
        authcookie_should_be_stored();
    }

    @Given("^I create a \"([^\"]*)\" flow and productCode \"([^\"]*)\"$")
    public void i_create_a_flow(String flowType, String productCode) throws Throwable {
        flowUrl = "?Request=" + flowType + "&ProductTypeCode=" + productCode;
        String url = appserver + context + cirpContext + flowUrl;
        performGet(url);
        flowUrl = "/pparam=ProductTypeCode=" + productCode + "/pparam=Request=NEW";
        response_should_have_status_code(200);
        authcookie_should_be_stored();
    }

    @Given("^With an Existing Policy I create a \"([^\"]*)\" flow and overeenkomstId \"([^\"]*)\" and productCode \"([^\"]*)\"$")
    public void with_an_existing_policy_i_create_a_flow(String flowType, String overeenkomstId, String productCode)
            throws Throwable {
        flowUrl = "?OvereenkomstId=" + overeenkomstId + "&Request=" + flowType + "&ProductTypeCode=" + productCode;
        String url = appserver + context + cirpContext + flowUrl;
        performGet(url);
        response_should_have_status_code(200);
        authcookie_should_be_stored();
    }

    @Given("^I start a flowType \"([^\"]*)\" flow and productTypeCode \"([^\"]*)\" and overeenkomstId \"([^\"]*)\" and object \"([^\"]*)\"$")
    public void i_modify_or_delete_a_flow(String flowType, String productTypeCode, String overeenkomstId, String object)
            throws Throwable {
        flowUrl = "?adminCode=14&typeCode=0897&processId=ORDER_CAPTURING&OvereenkomstId=" + overeenkomstId
                + "&ProductTypeCode=" + productTypeCode + "&Request=" + flowType;
        if (!object.contentEquals("")) {
            flowUrl = flowUrl + "&Object=" + object;
            // Piece of code to paste the ObjectTypeCode behind the Oldtimer insurance
            if (object.contentEquals("CROL01")) {
                flowUrl = flowUrl + "&ObjectTypeCode=90106";
            }
            if (object.contentEquals("MPOL01")) {
                flowUrl = flowUrl + "&ObjectTypeCode=90107";
            }
            if (object.contentEquals("MTOL01")) {
                flowUrl = flowUrl + "&ObjectTypeCode=90108";
            }
        }
        String url = appserver + context + cirpContext + flowUrl;
        performGet(url);
        response_should_have_status_code(200);
        authcookie_should_be_stored();
    }


    @Given("^I start a flowType \"([^\"]*)\" flow and productTypeCode \"([^\"]*)\" and overeenkomstId \"([^\"]*)\" and effectiveDate \"([^\"]*)\" and object \"([^\"]*)\"$")
    public void i_delete_a_future_create_flow(String flowType, String productTypeCode, String overeenkomstId, String effectiveDate, String object)
            throws Throwable {
        flowUrl = "?adminCode=14&typeCode=0897&processId=ORDER_CAPTURING&OvereenkomstId=" + overeenkomstId
                + "&ProductTypeCode=" + productTypeCode + "&Request=" + flowType + "&Object=" + object + "&effectiveDate=" + effectiveDate ;

        String url = appserver + context + cirpContext + flowUrl;
        performGet(url);
        response_should_have_status_code(200);
        authcookie_should_be_stored();
    }




    // CALL JSON ENDPOINTS

    @Given("^I compose \"([^\"]*)\" endpoint$")
    public void i_compose_endpoint(String endpointName) throws Throwable {
        String url = appserver + context + cirpContext + "/cirp/configure-insurance-retail-package/" + portletId
                + "/ver=2.0/resource/id=" + endpointName + ".wsp" + flowUrl;
        performGet(url);
    }

    @Given("^I compose \"([^\"]*)\" endpoint for virp$")
    public void i_compose_endpoint_for_virp(String endpointName) throws Throwable {
        String url = appserver + context + virpContext + "/virp/product-overview-insurance-retail-package/340931884/ver=2.0/resource/id=" + endpointName + ".wsp/pparam=OvereenkomstId="+overeenkomstId;
        performGet(url);
    }

    @Given("^I compose \"([^\"]*)\" endpoint for payload:$")
    public void i_compose_endpoint_with_payload(String endpointName, String payload) throws Throwable {
        String url = appserver + context + cirpContext + "/cirp/configure-insurance-retail-package/" + portletId
                + "/ver=2.0/resource/id=" + endpointName + ".wsp" + flowUrl;

        payload = payload.replace("dateChange", changeDatePost);
        performPost(url, "application/json; charset=UTF-8", payload);
    }

    @Then("^response should have status code \"([^\"]*)\"$")
    public void response_should_have_status_code(int statusCode) throws Throwable {
        response.then().statusCode(Matchers.equalTo(statusCode));
    }

    @Then("^response should be:$")
    public void reponse_should_be(String expected) throws Throwable {
        String output = response.body().asString();
        Assert.assertEquals(expected, output);
    }

    @Then("^response should contain:$")
    public void response_should_contain(String expected) throws Throwable {
        String output = response.body().asString();
        Assert.assertEquals(true, output.contains(expected));
    }


    @Then("^authCookie should be stored$")
    public void authcookie_should_be_stored() throws Throwable {

        String cookie = CookieUtil.getCookie();
        if (!cookie.contentEquals("default")) {
            authCookie = CookieUtil.getCookie();
        }

        List<String> cookies = response.headers().getValues("Set-Cookie");
        for (String rpy_cookie : cookies) {
            String[] values = rpy_cookie.split(";");
            String cookieCandidate = values[0];
            if (!cookieCandidate.contains("=\"\"")) {
                authCookie += values[0] + "; ";
            }

        }
        CookieUtil.setCookie(authCookie);
    }

    @Then("^XML \"([^\"]*)\" of \"([^\"]*)\" should contain:$")
    public void xml_of_log_should_match_with_file(String type, String serviceName, List<Entry> entries)
            throws Throwable
    {
        List<String> req_rpy;

        if (runLocal) {
            req_rpy = LogfileSearch.search(serviceName, piflogfile);
        } else {
            PifLogSearch pifLogSearch = new PifLogSearch();
            if (sshFlag){
                pifLogSearch.refreshLogfile();
            }else{
                PicomaClient client = new PicomaClient();
                client.login();
                client.refreshLogFile(appserverId);
                client.logout();
            }
            req_rpy = pifLogSearch.searchLogFileForServiceWithLimit(serviceName, 2000);
        }
        XmlUtil xmlUtil = null;

        if (type.contentEquals("req")) {
            try {
                xmlUtil = new XmlUtil(req_rpy.get(0));

                if (writeXml) {
                    scenario.write("<textarea rows=\"4\"  cols=\"80\">" + xmlUtil.prettyFormat(req_rpy.get(0), 3) + "</textarea>");
                }

            } catch (NullPointerException ex) {
                Assert.fail("No XML " + type + " for service " + serviceName + " was found in logs");
            }
        } else if (type.contentEquals("rpy")) {}

        for (Entry entry : entries) {
            String elValue = null;
            if (entry.name.startsWith("NVP:")) {
                elValue = xmlUtil.getXmlValueOfNameValuePair(entry.name);
            } else if (entry.name.contains(":")) {
                String[] names = entry.name.split(":");
                elValue = xmlUtil.getXmlValueOfElementByReference(names[0], names[1]);
            } else {
                elValue = xmlUtil.getXmlValueOfElement(entry.name);
            }
            //check for element not in xml
            if (entry.value.contentEquals("null")) {
                Assert.assertEquals(null, elValue);
            } else if(entry.value.startsWith("date")){
                if (entry.value.endsWith("Change")){
                    Assert.assertEquals(changeDate, elValue);
                }else {
                    Assert.assertEquals(XmlUtil.dateToString(new Date()), elValue);
                }
            } else {
                Assert.assertEquals(entry.value, elValue);
            }
        }

    }

    public class Authorization {
        public String authorization;
        public String policy;
    }
    public class Entry {
        String name;
        String value;
    }

    private Response performGet(String url) throws Throwable {
        System.out.println("Performing GET from: " + url);
        final Cookie cookie = new Cookie.Builder(CookieUtil.getCookie()).build();
        response = RestAssured.given().cookie(cookie).get(url);
        return response;
    }

    private Response performPost(String url, String contentType, String body) throws Throwable {
        System.out.println("Performing POST to: " + url);
        final Cookie cookie = new Cookie.Builder(CookieUtil.getCookie()).build();
        response = RestAssured.given().cookie(cookie).contentType(contentType).body(body).post(url);
        return response;
    }
}
