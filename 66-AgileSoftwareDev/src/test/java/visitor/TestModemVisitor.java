package visitor;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;


public class TestModemVisitor {
    private UnixModemConfigurator modemVisitor;
    private HayesModem hayesModem;
    private ZoomModem zoomModem;
    private ErnieModem ernieModem;

    @Before
    public void setUp() {
        modemVisitor = new UnixModemConfigurator();
        hayesModem = new HayesModem();
        zoomModem = new ZoomModem();
        ernieModem = new ErnieModem();
    }

    @Test
    public void testHayesForUnix() {
        hayesModem.accept(modemVisitor);
        Assert.assertEquals("&s1=4&D=3", hayesModem.configurationString);
    }

    @Test
    public void testZoomForUnix() {
        zoomModem.accept(modemVisitor);
        Assert.assertEquals(42, zoomModem.configurationString);
    }

    @Test
    public void testErnieForUnix() {
        ernieModem.accept(modemVisitor);
        Assert.assertEquals("C is too slow", ernieModem.configurationPattern);
    }
}
