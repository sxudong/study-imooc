package observer.v3;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * 程序24.13 P267
 */
public class ClockDriverTest {
    private MockTimeSource source;
    private MockTimeSink sink;

    @Before
    public void setUp() {
        source = new MockTimeSource();
        sink = new MockTimeSink();
        source.registerObserver(sink);
    }

    @Test
    public void testTimeChange() {
        source.setTime(3, 4, 5);
        assertSinkEquals(sink, 3, 4, 5);

        source.setTime(7, 8, 9);
        assertSinkEquals(sink, 7, 8, 9);
    }

    @Test
    public void testMultipleSinks() {
        MockTimeSink sink2 = new MockTimeSink();
        source.registerObserver(sink2);

        source.setTime(12, 13, 14);
        assertSinkEquals(sink, 12, 13, 14);
        assertSinkEquals(sink2, 12, 13, 14);
    }

    private void assertSinkEquals(MockTimeSink sink, int hours, int minutes, int seconds) {
        Assert.assertEquals(hours, sink.getHours());
        Assert.assertEquals(minutes, sink.getMinutes());
        Assert.assertEquals(seconds, sink.getSeconds());
    }
}
