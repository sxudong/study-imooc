package visitor.example;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.Iterator;

/**
 * 程序28.23
 */
public class TestB0MReport {
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
        PiecePart p = (PiecePart)i.next();
        Assert.assertEquals(p, p1);
        p = (PiecePart)i.next();
        Assert.assertEquals(p, p2);
        Assert.assertTrue(i.hasNext() == false);
    }

    @Test
    public void testAssemblyOfAssemblies() {
        Assembly subAssembly = new Assembly("1234", "SubAssembly");
        subAssembly.add(p1);
        a.add(subAssembly);
        Iterator i = a.getParts();
        Assert.assertEquals(subAssembly, i.next());
    }

    private boolean p1Fount = false;
    private boolean p2Fount = false;
    private boolean aFount = false;

    @Test
    public void testVisitorCoverage() {
        a.add(p1);
        a.add(p2);
        a.accept(new PartVisitor() {
            @Override
            public void visit(PiecePart p) {
                if (p == p1) {
                    p1Fount = true;
                } else if (p == p2) {
                    p2Fount = true;
                }
            }

            @Override
            public void visit(Assembly assy) {
                if (assy == a) {
                    aFount = true;
                }
            }
        });
        assert(p1Fount);
        assert(p2Fount);
        assert(aFount);
    }

    private Assembly cellphone;

    void setUpReportDatabase() {
        cellphone = new Assembly("CP-7737", "Cell Phone");
        PiecePart display = new PiecePart("DS-1428", "LCD Display", 14.37);
        PiecePart speaker = new PiecePart("SP-92", "Speaker", 3.50);
        PiecePart microphone = new PiecePart("MC-28", "Microphone", 5.30);
        PiecePart cellRadio = new PiecePart("CR-56", "Cell Radio", 30);
        PiecePart frontCover = new PiecePart("FC-77", "Front Cover", 1.4);
        PiecePart backCover = new PiecePart("RC-77", "Back Cover", 1.2);
        Assembly keypad = new Assembly("KP-62", "Keypad");
        Assembly button = new Assembly("B52", "Button");
        PiecePart buttonCover = new PiecePart("CV-15", "Cover", .5);
        PiecePart buttonContact = new PiecePart("CN-2", "Contact", 1.2);
        button.add(buttonCover);
        button.add(buttonContact);
        for (int i = 0; i < 15; i++) {
            keypad.add(button);
        }
        cellphone.add(display);
        cellphone.add(speaker);
        cellphone.add(microphone);
        cellphone.add(cellRadio);
        cellphone.add(frontCover);
        cellphone.add(backCover);
        cellphone.add(keypad);
    }

    @Test
    public void testExplodedCost() {
        setUpReportDatabase();
        ExplodedCostVisitor v = new ExplodedCostVisitor();
        cellphone.accept(v);
        Assert.assertEquals(81.27, v.cost(), .001);
    }

    @Test
    public void testPartCount() {
        setUpReportDatabase();
        PartCountVisitor v = new PartCountVisitor();
        cellphone.accept(v);
        Assert.assertEquals(36, v.getPieceCount());
        Assert.assertEquals(8, v.getPartNumberCount());
        Assert.assertEquals("DS-1428", 1, v.getCountForPart("DS-1428"));
        Assert.assertEquals("SP-92", 1,  v.getCountForPart("SP-92"));
        Assert.assertEquals("MC-28", 1,  v.getCountForPart("MC-28"));
        Assert.assertEquals("CR-56", 1,  v.getCountForPart("CR-56"));
        Assert.assertEquals("RC-77", 1,  v.getCountForPart("RC-77"));
        Assert.assertEquals("CV-15", 15,  v.getCountForPart("CV-15"));
        Assert.assertEquals("CN-2", 15,  v.getCountForPart("CN-2"));
        Assert.assertEquals("Bob", 0,  v.getCountForPart("Bob"));
    }

}
