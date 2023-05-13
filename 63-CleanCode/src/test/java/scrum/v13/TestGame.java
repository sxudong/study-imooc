package scrum.v13;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

/**
 * P66~P68
 * 重构
 */
public class TestGame {
    private Game game;

    @Before
    public void SetUp() {
        game = new Game();
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

    @Test
    public void testPerfectGame() {
        for (int i = 0; i < 12; i++) {
            game.add(10);
        }
        assertEquals(300, game.score());
        assertEquals(11, game.getCurrentFrame());
    }

    @Test
    public void testEndOfArray() {
        for (int i = 0; i < 9; i++) {
            game.add(0);
            game.add(0);
        }
        game.add(2);
        game.add(8);
        game.add(10);
        // 由于score决不会用大于10的参数去调用 scoreForFrame，所以这最后一次全中实际上没有被作为全中处理。
        // 只是为了最后一轮补中的完整性才把它作为 10 分计算的。我们决不会越过数组的边界。
        assertEquals(20, game.score());
    }

    @Test
    public void testSimpleGame() { // Spare 补中
        Game game = new Game();
        game.add(1);
        game.add(4);
        game.add(4);
        game.add(5);
        game.add(6);
        game.add(4);
        game.add(5);
        game.add(5);
        game.add(10);
        game.add(0);
        game.add(1);
        game.add(7);
        game.add(3);
        game.add(6);
        game.add(4);
        game.add(10);
        game.add(2);
        game.add(8);
        game.add(6);
        assertEquals(133, game.score());
    }

    /**
     * 边界测试
     * 一个可怜的家伙投掷出了 11 次全中。而最后一次仅击中了 9 个。
     */
    @Test
    public void testHeartBreak() {
        for (int i = 0; i < 11; i++) {
            game.add(10);
        }
        game.add(9);
        assertEquals(299, game.score());
    }

    /**
     * 边界测试
     * 测试一下第 10 轮是补中的情况
     */
    @Test
    public void testTenthFrameSpare() {
        for (int i = 0; i < 9; i++) {
            game.add(10);
        }
        game.add(9);
        game.add(1);
        game.add(1);
        assertEquals(270, game.score());
    }
}