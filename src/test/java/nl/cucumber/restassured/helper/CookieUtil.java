package nl.cucumber.restassured.helper;

import java.io.*;

public final class CookieUtil {

    public static String getCookie() {

        String result = "default";
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader("cookie.txt"));
            result = reader.readLine();
            reader.close();
        }
        catch(Exception e)
        {
        }
        finally{
            try {
                reader.close();
            } catch (IOException e) {}
        }
        return result;
    }

    public static void setCookie(String cookie) {

        BufferedWriter writer = null;
        try {
            writer = new BufferedWriter(new FileWriter("cookie.txt"));
            writer.write(cookie);
            writer.close();
        }
        catch(Exception e)
        { //ignore
        }
        finally{
            try {
                writer.close();
            } catch (IOException e) {}
        }
    }

}
