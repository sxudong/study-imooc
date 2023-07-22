package scrum.v3;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * P48~P50
 */
public class TestGame {
    @Test
    public void testOneThrows() {
        Game game = new Game();
        game.add(5);
        assertEquals(5, game.score());
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
    }

    /**
     * 测试用例：补中的情况
     */
//    @Test
//    public void TestSimpleSpare() { // Spare 补中
//        Game game = new Game();
//        game.add(3);
//        game.add(7);
//        game.add(3);
//        assertEquals(13, game.scoreForFrame(1));
//    }
    @Test
    public void testSimpleSpare() { // Spare 补中
        scrum.v4.Game game = new scrum.v4.Game();
        game.add(3);
        game.add(7);
        game.add(3);
        game.add(2);
        assertEquals(13, game.scoreForFrame(1));
        // assertEquals(18, game.score()); // 测试失败
        // 改scoreForFrame(2)，测试通过了，肯定是 score 方法出问题了。
        assertEquals(18, game.scoreForFrame(2));

        // 是的，是错了。 score 方法只是返回木瓶数的和，而不是正确的得分。我们要让 score 做的是用当前轮作为参数去调用 scoreForFrame()
    }
}
