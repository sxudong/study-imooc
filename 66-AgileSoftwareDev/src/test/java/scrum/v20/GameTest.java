package scrum.v20;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * 《敏捷软件开发 原则、模式与实践》第6章 一次编程实践 P71~P75
 */
public class GameTest {
    private Game game;

    @Before
    public void SetUp() {
        game = new Game();
    }

    @Test
    public void TestTwoThrowNoMark() {
        game.Add(5);
        game.Add(4);
        Assert.assertEquals(9, game.Score());
    }

    @Test
    public void TestFourThrowNoMark() {
        game.Add(5);
        game.Add(4);
        game.Add(7);
        game.Add(2);
        Assert.assertEquals(18, game.Score());
        Assert.assertEquals(9, game.ScoreForFrame(1));
        Assert.assertEquals(18, game.ScoreForFrame(2));
    }

    @Test
    public void TestSimpleSpare() {
        game.Add(3);
        game.Add(7);
        game.Add(3);
        Assert.assertEquals(13, game.ScoreForFrame(1));
    }

    @Test
    public void TestSimpleFrameAfterSpare() {
        game.Add(3);
        game.Add(7);
        game.Add(3);
        game.Add(2);
        Assert.assertEquals(13, game.ScoreForFrame(1));
        Assert.assertEquals(18, game.ScoreForFrame(2));
        Assert.assertEquals(18, game.Score());
    }

    @Test
    public void TestSimpleStrike() {
        game.Add(10);
        game.Add(3);
        game.Add(6);
        Assert.assertEquals(19, game.ScoreForFrame(1));
        Assert.assertEquals(28, game.Score());
    }

    @Test
    public void TestPerfectGame() {
        for (int i = 0; i < 12; i++) game.Add(10);
        Assert.assertEquals(300, game.Score());
    }

    @Test
    public void TestEndOfArray() {
        for (int i = 0; i < 9; i++) {
            game.Add(0);
            game.Add(0);
        }
        game.Add(2);
        game.Add(8);
        game.Add(10);
        Assert.assertEquals(20, game.Score());
    }

    @Test
    public void TestSampleGame() {
        game.Add(1);
        game.Add(4);
        game.Add(4);
        game.Add(5);
        game.Add(6);
        game.Add(4);
        game.Add(5);
        game.Add(5);
        game.Add(10);
        game.Add(0);
        game.Add(1);
        game.Add(7);
        game.Add(3);
        game.Add(6);
        game.Add(4);
        game.Add(10);
        game.Add(2);
        game.Add(8);
        game.Add(6);
        Assert.assertEquals(133, game.Score());
    }

    @Test
    public void TestHeartBreak() {
        for (int i = 0; i < 11; i++) game.Add(10);
        game.Add(9);
        Assert.assertEquals(299, game.Score());
    }

    @Test
    public void TestTenthFrameSpare() {
        for (int i = 0; i < 9; i++) game.Add(10);
        game.Add(9);
        game.Add(1);
        game.Add(1);
        Assert.assertEquals(270, game.Score());
    }
}