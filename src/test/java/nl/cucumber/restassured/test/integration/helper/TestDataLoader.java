package nl.cucumber.restassured.test.integration.helper;

import nl.cucumber.restassured.test.integration.BasicRestSteps;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;


public class TestDataLoader {


    final static HashMap<String, String> userIdmap = new HashMap<String, String>();
    {
        userIdmap.put("NickWilde","999990000000987");
        userIdmap.put("JudyHopps","999990000000438");
        userIdmap.put("ChiefBogo","999990000000888");
        userIdmap.put("LeodoreLionheart","999990000000444");
    }

    StubDataLoader stubDataLoader;

    public void adjustKAD(String userName, List<BasicRestSteps.Authorization> auths){

        String policyNr;
        boolean canRead;
        boolean canChange;
        JSONObject json = null;
        String relationId = userIdmap.get(userName);
        URL url = this.getClass().getClassLoader().getResource("testdata/template/pif-stubs/KAD/getAllPersonArrangementAuthorizations/"+relationId+".json");

        try {
            for (BasicRestSteps.Authorization auth : auths){
                String rights = "[\"PS_DB_03\",\"PS_DB_04\",\"PS_DB_06\",\"PS_DB_08\",\"PS_DB_11\",\"PS_DB_09\",\"PS_CR_01\",\"PS_CR_02\",\"PS_CR_03\"";
                policyNr = auth.policy;
                canRead = hasAuthorization(auth.authorization,"GN_READ") ? true : false;
                canChange = hasAuthorization(auth.authorization,"GN_CHANGE") ? true : false;

                if (json == null) {
                    json = (JSONObject) new JSONParser().parse(getDataAsString(new File(url.toURI())));
                }
                JSONObject authorizations = (JSONObject) new JSONParser().parse(json.get("authorizations").toString());
                JSONArray arrangements = (JSONArray) new JSONParser().parse(authorizations.get("arrangements").toString());
                if (arrangements.size() >= 1 ){
                    for (int i = 0; i < arrangements.size(); i++) {
                        JSONObject arrangement = (JSONObject) new JSONParser().parse(arrangements.get(i).toString());
                        if (arrangement.get("arrangementNumber").equals(policyNr)) {
                            if (canRead) {
                                rights += ",\"GN_READ\"";
                            }
                            if (canChange) {
                                rights += ",\"GN_CHANGE\"";
                            }
                            rights += "]";
                            JSONArray array = (JSONArray)new JSONParser().parse(rights);
                            arrangement.put("rights",array.toJSONString().replaceAll("\\\"","\""));
                            arrangements.set(i, arrangement);
                            authorizations.put("arrangements", arrangements);
                            json.put("authorizations", authorizations);
                        }
                    }
                }
            }
            String result = json.toJSONString().replaceAll("\"\\[","\\[");
            result = result.replaceAll("\\]\"","\\]");
            result = result.replaceAll("\\\\\"","\"");
            String escapeString = result.substring(result.lastIndexOf("\"user\":"),result.lastIndexOf("}]}") );
            String escapeResult = escapeString.replaceAll("\"","\\\\\"");
            result = result.replace(escapeString,escapeResult);
            result = result.replace("zations\":{","zations\":\"{");
            result = result.replace("}]}","}]}\"");
            setDataAsString(result, url);
            updateData();
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private boolean hasAuthorization(String input, String check){
        return input.contains(check) ? true : false;
    }

    private void updateData(){
        stubDataLoader = new StubDataLoader();
        URL configURL = this.getClass().getClassLoader().getResource("testdata/config.json");
        try {
            JSONObject json = (JSONObject)new JSONParser().parse(getDataAsString(new File(configURL.toURI())));
            json.put("testData", configURL.getPath().substring(1, configURL.getPath().length()-11) + "template");
            setDataAsString(json.toJSONString(),configURL);
            stubDataLoader.loadStubData(new String[]{configURL.getPath()});
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    private void setDataAsString(String data, URL url) throws IOException {
        FileWriter fw =null;
        try {
            fw = new FileWriter(new File(url.toURI()));
            fw.write(data);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        } finally {
            fw.close();
        }
    }

    private String getDataAsString(File f) {
        byte[] encoded = new byte[0];
        String result = null;
        try {
            encoded = Files.readAllBytes(f.toPath());
            result = new String(encoded, "UTF-8");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

}
