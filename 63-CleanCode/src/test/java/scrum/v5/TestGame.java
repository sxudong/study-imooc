package scrum.v5;

import org.junit.Test;
import static org.junit.Assert.assertEquals;

/**
 * P50~P53
 */
public class TestGame {
    @Test
    public void testOneThrows() {
        Game game = new Game();
        game.add(5);
        assertEquals(5, game.score());
        assertEquals(1, game.getCurrentFrame());
    }

    /**
     * 测试用例：2个投掷，但没有补中的情况
     */
    @Test
    public void testTwoThrows() {
        Game game = new Game();
        game.add(5);
        game.add(4);
        assertEquals(9, game.score());
        assertEquals(2, game.getCurrentFrame());
    }

    /**
     * 测试用例：4个投掷，但没有补中和全中的情况
     */
    @Test
    public void testFourThrows() {
        Game game = new Game();
        game.add(5);
        game.add(4);
        game.add(7);
        game.add(2);
        assertEquals(18, game.score());
        assertEquals(9, game.scoreForFrame(1));
        assertEquals(18, game.scoreForFrame(2));
        assertEquals(3, game.getCurrentFrame());
    }

    /**
     * 测试用例：补中的情况
     */
    @Test
    public void testSimpleSpare() { // Spare 补中
        Game game = new Game();
        game.add(3);
        game.add(7);
        game.add(3);
        assertEquals(13, game.scoreForFrame(1));
        assertEquals(2, game.getCurrentFrame());
    }

    /**
     * 测试用例：补中的情况
     */
    @Test
    public void testSimpleFrameAfterSpare() {
        Game game = new Game();
        game.add(3);
        game.add(7);
        game.add(3);
        game.add(2);
        assertEquals(13, game.scoreForFrame(1));
        assertEquals(3, game.getCurrentFrame());
    }
}