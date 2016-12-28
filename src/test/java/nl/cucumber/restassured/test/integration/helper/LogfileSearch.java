/**
 *
 */
package nl.cucumber.restassured.test.integration.helper;

import nl.cucumber.restassured.test.integration.Config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

/**
 * For Developers to run in local development environment
 * To use this class set runlocal flag to true in restassured.properties
 */
public class LogfileSearch extends Config {


    public static List<String> search(String serviceName, String logfile) throws IOException {


        Runtime rt = Runtime.getRuntime();

        try { //local logfile update can be slow for large orders so sleep 5 seconds
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        String cmd =
                "C:\\obw\\apps\\UnxUtils\\usr\\local\\wbin\\grep -G \"nl.rabobank.gict.crmvirtueel.cirp_stub.*"
                        + serviceName + "\" " + logfile;
        System.out.println(cmd);
        Process proc = rt.exec(cmd);

        List<String> result = new ArrayList<String>(2);
        String request = "";
        String reply = "";

        BufferedReader is = new BufferedReader(new InputStreamReader(proc.getInputStream()));
        try {
            String line;
            while ((line = is.readLine()) != null) {
                if (line.contains("request body")) {
                    request = line;
                }
                if (line.contains("response body")) {
                    reply = line;
                }
            }
        } finally {
            is.close();
        }
        result.add(request.substring(request.indexOf("<soapenv")));
        result.add(reply.substring(reply.indexOf("<soapenv")));
        return result;
    }

}
