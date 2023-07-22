package scrum.chapter16;

import junit.framework.TestCase;

/**
 * 《敏捷软件开发》第16章 运用 MONOSTATE（单态）模式 P165
 */
public class TestTurnstile extends TestCase {
    public TestTurnstile(String name) {
        super(name);
    }

    public void setUp() {
        Turnstile t = new Turnstile();
        t.reset();
    }

    public void testInit() {
        Turnstile t = new Turnstile();
        assert (t.locked());
        assert (!t.alarm());
    }

    public void testCoin() {
        Turnstile t = new Turnstile();
        t.coin();
        Turnstile t1 = new Turnstile();
        assert (!t1.locked());
        assert (!t1.alarm());
        assertEquals(1, t1.coins());
    }

    public void testCoinAndPass() {
        Turnstile t = new Turnstile();
        t.coin();
        t.pass();

        Turnstile t1 = new Turnstile();
        assert (t1.locked());
        assert (!t1.alarm());
        assertEquals("coins", 1, t1.coins());
    }

    public void testTwoCoins() {
        Turnstile t = new Turnstile();
        t.coin();
        t.coin();

        Turnstile t1 = new Turnstile();
//        assertEquals("unlocked", !t1.locked());
        assert (!t1.locked());
        assertEquals("coins", 1, t1.coins());
        assertEquals("refunds", 1, t1.refunds());
        assert (!t1.alarm());
    }

    public void testPass() {
        Turnstile t = new Turnstile();
        t.pass();
        Turnstile t1 = new Turnstile();
        assert (t1.alarm());
        assert (t1.locked());
    }

    public void testCancelAlarm() {
        Turnstile t = new Turnstile();
        t.pass();
        t.coin();
        Turnstile t1 = new Turnstile();
        assert (!t1.alarm());
        assert (!t1.locked());
        assertEquals("coin", 1, t1.coins());
        assertEquals("refund", 0, t1.refunds());
    }

    public void testTwoOperations() {
        Turnstile t = new Turnstile();
        t.coin();
        t.pass();
        t.coin();
        assert (!t.locked());
        assertEquals("coins", 2, t.coins());
        t.pass();
        assert (t.locked());
    }
}

