package nl.cucumber.restassured.test.integration;

import java.util.ResourceBundle;

public class Config {
    protected static String appserver;
    protected static String appserverId;
    protected static String stubserver;
    protected static String portletId;
    protected static boolean runLocal;
    protected static String piflogfile;
    protected static String context;
    protected static String virpContext;
    protected static String cirpContext;
    protected static boolean sshFlag;
    protected static boolean writeXml;

    public static void loadConfig() {
        ResourceBundle rb = ResourceBundle.getBundle("restassured");
        writeXml = Boolean.parseBoolean(rb.getString("writeXML"));
        portletId = rb.getString("portletId");
        appserver = rb.getString("appserver");
        appserverId = rb.getString("appserverId");
        stubserver = rb.getString("stubserver");
        runLocal = Boolean.parseBoolean(rb.getString("runlocal.flag"));
        piflogfile = rb.getString("runlocal.piflog.location");
        context = rb.getString("context");
        virpContext = rb.getString("virp.context");
        cirpContext = rb.getString("cirp.context");
        sshFlag = Boolean.parseBoolean(rb.getString("ssh.flag"));
    }
}
