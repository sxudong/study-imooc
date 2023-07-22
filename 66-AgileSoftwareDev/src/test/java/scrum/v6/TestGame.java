package scrum.v6;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * P50~P56
 */
public class TestGame {
    private Game game;

    @Before
    public void SetUp() {
        game = new Game();
    }

    /**
     * 只有一次投掷，第1轮是不完整的。谁会去调用 score() 呢？假定不会针对不完整轮调用该方法合理吗？
     * 为了解决这个问题，我们要从 testOneThrows 测试用例中去掉score？可以这样做，甚至可以去掉整个
     * testOneThrows 测试用例。
     */
//    @Test
//    public void testOneThrows() {
//        Game game = new Game();
//        game.add(5);
//        assertEquals(5, game.score());
//        assertEquals(1, game.getCurrentFrame());
//    }

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
        assertEquals(18, game.scoreForFrame(2));
        assertEquals(18, game.score());
        assertEquals(3, game.getCurrentFrame());
    }

    @Test
    public void test() {
        Game game = new Game();
        game.add(10);
        game.add(3);
        game.add(6);
        assertEquals(19, game.scoreForFrame(1));
        assertEquals(28, game.score());
        assertEquals(3, game.getCurrentFrame());
    }

    /**
     * 奇怪，它说得分是 330.怎么会是这样？因为当前轮一直被累加到12.
     * 要把它限定到 10
     */
    @Test
    public void testPerfectGame() {
        for (int i = 0; i < 12; i++) {
            game.add(10);
        }
        assertEquals(300, game.score());
        assertEquals(10, game.getCurrentFrame());
    }
    /* output:
        java.lang.AssertionError:
        Expected :300
        Actual   :330
     */
}