package scrum.v1;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class TestFrame {
    @Test
    public void testScoreNoThrows() {
        Frame f = new Frame();
        assertEquals(0, f.getScore());
    }

    @Test
    public void testAddOneThrows() {
        Frame f = new Frame();
        f.add(5);
        assertEquals(5, f.getScore());
    }
}
