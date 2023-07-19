package extensionObject;

import org.jdom2.Element;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.Iterator;
import java.util.List;

/**
 * 程序28.30 P359
 */
public class TestBOMXML {
    private PiecePart p1;
    private PiecePart p2;
    private Assembly a;

    @Before
    public void setUp() {
        p1 = new PiecePart("997624", "MyPart", 3.20);
        p2 = new PiecePart("7734", "Hell", 666);
        a = new Assembly("5879", "MyAssembly");
    }

    @Test
    public void testCreatePart() {
        Assert.assertEquals("997624", p1.getPartNumber());
        Assert.assertEquals("MyPart", p1.getDescription());
        Assert.assertEquals(3.20, p1.getCost(), .01);
    }

    @Test
    public void testCreateAssembly() {
        Assert.assertEquals("5879", a.getPartNumber());
        Assert.assertEquals("MyAssembly", a.getDescription());
    }

    @Test
    public void testAssembly() {
        a.add(p1);
        a.add(p2);
        Iterator i = a.getParts();
        PiecePart p = (PiecePart) i.next();
        Assert.assertEquals(p, p1);
        p = (PiecePart) i.next();
        Assert.assertEquals(p, p2);
        Assert.assertTrue(i.hasNext() == false);
    }

    @Test
    public void testAssemblyOfAssemblies() {
        Assembly subAssembly = new Assembly("5879", "SubAssembly");
        subAssembly.add(p1);
        a.add(subAssembly);

        Iterator i = a.getParts();
        Assert.assertEquals(subAssembly, i.next());
    }

    @Test
    public void testPiecePart1XML() {
        PartExtension e = p1.getExtension("XML");
        XMLPartExtension xe = (XMLPartExtension) e;
        Element xml = xe.getXMLElement();

        Assert.assertEquals("PiecePart", xml.getName());
        Assert.assertEquals("997624", xml.getChild("PartNumber").getTextTrim());
        Assert.assertEquals("MyPart", xml.getChild("Description").getTextTrim());
        Assert.assertEquals(3.2, Double.parseDouble(xml.getChild("Cost").getTextTrim()), 0.1);
    }

    @Test
    public void testPiecePart2XML() {
        PartExtension e = p2.getExtension("XML");
        XMLPartExtension xe = (XMLPartExtension) e;
        Element xml = xe.getXMLElement();

        Assert.assertEquals("PiecePart", xml.getName());
        Assert.assertEquals("7734", xml.getChild("PartNumber").getTextTrim());
        Assert.assertEquals("Hell", xml.getChild("Description").getTextTrim());
        Assert.assertEquals(666, Double.parseDouble(xml.getChild("Cost").getTextTrim()), 0.1);
    }

    @Test
    public void testSimpleAssemblyXML() {
        PartExtension e = a.getExtension("XML");
        XMLPartExtension xe = (XMLPartExtension) e;
        Element xml = xe.getXMLElement();

        Assert.assertEquals("Assembly", xml.getName());
        Assert.assertEquals("5879", xml.getChild("PartNumber").getTextTrim());
        Assert.assertEquals("MyAssembly", xml.getChild("Description").getTextTrim());

        Element parts = xml.getChild("Parts");
        List<Element> partList = parts.getChildren();
        Assert.assertEquals(0, partList.size());
    }

    @Test
    public void testAssemblyWithPartsXML() {
        a.add(p1);
        a.add(p2);
        PartExtension e = a.getExtension("XML");
        XMLPartExtension xe = (XMLPartExtension) e;
        Element xml = xe.getXMLElement();

        Assert.assertEquals("Assembly", xml.getName());
        Assert.assertEquals("5879", xml.getChild("PartNumber").getTextTrim());
        Assert.assertEquals("MyAssembly", xml.getChild("Description").getTextTrim());

        Element parts = xml.getChild("Parts");
        List<Element> partList = parts.getChildren();
        Assert.assertEquals(2, partList.size());

        Iterator i = partList.iterator();
        Element partElement = (Element) i.next();
        Assert.assertEquals("PiecePart", partElement.getName());
        Assert.assertEquals("997624", partElement.getChild("PartNumber").getTextTrim());

        partElement = (Element)  i.next();
        Assert.assertEquals("PiecePart", partElement.getName());
        Assert.assertEquals("7734", partElement.getChild("PartNumber").getTextTrim());
    }

    @Test
    public void testPiecePart1CSV() {
        PartExtension e = p1.getExtension("CSV");
        CSVPartExtension xe = (CSVPartExtension) e;
        String csv = xe.getCSV();
        Assert.assertEquals("PiecePart,997624,MyPart,3.2", csv);
    }

    @Test
    public void testPiecePart2CSV() {
        PartExtension e = p2.getExtension("CSV");
        CSVPartExtension xe = (CSVPartExtension) e;
        String csv = xe.getCSV();
        Assert.assertEquals("PiecePart,7734,Hell,666.0", csv);
    }

    @Test
    public void testAssemblyCSV() {
        PartExtension e = a.getExtension("CSV");
        CSVPartExtension xe = (CSVPartExtension) e;
        String csv = xe.getCSV();
        Assert.assertEquals("Assembly,5879,MyAssembly", csv);
    }

    @Test
    public void testAssemblyWithPartsCSV() {
        a.add(p1);
        a.add(p2);
        PartExtension e = a.getExtension("CSV");
        CSVPartExtension xe = (CSVPartExtension) e;
        String csv = xe.getCSV();

        Assert.assertEquals("Assembly,5879,MyAssembly,"
                + "{PiecePart,997624,MyPart,3.2},"
                + "{PiecePart,7734,Hell,666.0}", csv);
    }

    @Test
    public void testBadExtension() {
        PartExtension pe = p1.getExtension("This String Doesn't Match Any Exception");
        assert(pe instanceof BadPartExtenstion);
    }

}
