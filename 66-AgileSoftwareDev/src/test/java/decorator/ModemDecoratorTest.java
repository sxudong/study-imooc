package decorator;

import org.junit.Assert;
import org.junit.Test;

/**
 * 程序28.27 P356
 */
public class ModemDecoratorTest {

    @Test
    public void testCreateHayes() {
        Modem hayesModem = new HayesModem();
        Assert.assertEquals(null, hayesModem.getPhoneNumber());
        hayesModem.dial("5551212");
        Assert.assertEquals("5551212", hayesModem.getPhoneNumber());
        hayesModem.setSpeakerVolume(10);
        Assert.assertEquals(10,hayesModem.getSpeakerVolume());
    }

    @Test
    public void testCreateLoudDialModem() {
        Modem hayesModem = new HayesModem();
        Modem loudDialModem = new LoudDialModem(hayesModem);
        Assert.assertEquals(null, loudDialModem.getPhoneNumber());
        Assert.assertEquals(0, loudDialModem.getSpeakerVolume());
        loudDialModem.dial("5551212");
        Assert.assertEquals("5551212", loudDialModem.getPhoneNumber());
        loudDialModem.setSpeakerVolume(10);
        Assert.assertEquals(10,loudDialModem.getSpeakerVolume());
    }
}
