package nl.cucumber.restassured.helper;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by kayipcheung on 31/01/2017.
 */
public class JSONReader {

    ArrayList<String> raceNameList = new ArrayList<>();

    public ArrayList<String> readRacesFromFile(String file) {
        JSONParser parser = new JSONParser();
        try {
            Object obj = parser.parse(new FileReader(file));
            JSONObject jsonObject = (JSONObject) obj;
            JSONObject mrdata = (JSONObject) jsonObject.get("MRData");
            JSONObject raceTable = (JSONObject) mrdata.get("RaceTable");
            JSONArray raceList = (JSONArray) raceTable.get("Races");
            for(int i = 0; i < raceList.size(); i++) {
                JSONObject raceName = (JSONObject) raceList.get(i);
                String r = (String) raceName.get("raceName");
                raceNameList.add(r);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return raceNameList;
    }
}
