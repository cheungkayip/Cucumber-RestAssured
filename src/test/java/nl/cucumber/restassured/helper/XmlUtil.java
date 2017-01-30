package nl.cucumber.restassured.helper;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.StringReader;
import java.io.StringWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class XmlUtil {

    Document xmlDocument = null;

    public XmlUtil(String xml) throws Exception
    {
        DocumentBuilderFactory fctr = DocumentBuilderFactory.newInstance();
        DocumentBuilder bldr = fctr.newDocumentBuilder();
        InputSource insrc = new InputSource(new StringReader(xml));
        xmlDocument = bldr.parse(insrc);
    }

    /**
     * Simple function to loop through xml document and return value of matching element
     * @param name
     * @return nodeValue of matching element if found and null if not found
     */
    public String getXmlValueOfElement(String name) {
        String result = null;
        NodeList entries = xmlDocument.getElementsByTagName("*");
        for (int i = 0; i < entries.getLength(); i++) {
            Element element = (Element) entries.item(i);
            //handle namespaces
            if (element.getNodeName().contains(":"))  {
                String[] el_split = element.getNodeName().split(":");
                if (el_split[1].contentEquals(name)) {
                    result = element.getTextContent();
                    break;
                }
            } else if (element.getNodeName().contentEquals(name)){
                result = element.getTextContent();
                break;
            }
        }
        return result;
    }

    /**
     * Simple function to loop through xml document and return value of matching NVP
     * @param name
     * @return AttributeValue of matching element if found and null if not found
     */
    public String getXmlValueOfNameValuePair(String name) {
        String result = null;
        name = name.substring(4); //start at position 4 ignoring namespace prefix
        NodeList entries = xmlDocument.getElementsByTagName("*");
        for (int i = 0; i < entries.getLength(); i++) {
            Element element = (Element) entries.item(i);
            //handle namespaces
            if (element.getNodeName().contains(":")) {
                String[] el_split = element.getNodeName().split(":");
                if (el_split[1].contentEquals("AttributeName")){
                    if (element.getTextContent().contentEquals(name)) {
                        result = element.getNextSibling().getNextSibling().getTextContent();
                        break;
                    }
                }

            }else if (element.getNodeName().contentEquals("AttributeName")){
                if (element.getTextContent().contentEquals(name)) {
                    result = element.getNextSibling().getNextSibling().getTextContent();
                    break;
                }
            }
        }
        return result;
    }

    /**
     * Function to convert date to String for xml compare
     * @param date
     * @return date to String
     */
    public static String dateToString(Date date) {
        DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        return dateFormat.format(date);
    }

    /**
     * Function to convert date to String for JSON post
     * @param date
     * @return date to String
     */
    public static String dateToPostString(Date date) {
        DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        return dateFormat.format(date);
    }

    /**
     * Simple function to get value of element by elementNameAbove
     * @param elementNameAbove the element above the element to search for
     * @param name the name of the element
     * @return nodeValue of matching element if found and null if not found
     */
    public String getXmlValueOfElementByReference(String elementNameAbove, String name){
        String result = null;
        XPath xpath = XPathFactory.newInstance().newXPath();
        try {
            result = xpath.evaluate("//*[local-name()='"+elementNameAbove+"']//*[local-name()='"+name+"']/text()", xmlDocument);
        } catch (XPathExpressionException e) {
            e.printStackTrace();
        }
        return  result;
    }

    /**
     * Nice formatting of xml
     * @param input the xml input as String
     * @param indent the indentation of the elements
     * @return formatted xml with indent n
     */
    public String prettyFormat(final String input, final int indent) {
        try {
            final Source xmlInput = new StreamSource(new StringReader(input));
            final StringWriter stringWriter = new StringWriter();
            final StreamResult xmlOutput = new StreamResult(stringWriter);
            final TransformerFactory transformerFactory = TransformerFactory.newInstance();
            transformerFactory.setAttribute("indent-number", indent);
            final Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.transform(xmlInput, xmlOutput);
            return xmlOutput.getWriter().toString();
        } catch (final Exception ex) {
            return ex.getMessage();
        }
    }

}
