package state.v3;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class TestTurnstile {
    private Turnstile t;
    private boolean lockCalled = false;
    private boolean unlockCalled = false;
    private boolean thankyouCalled = false;
    private boolean alarmCalled = false;

    @Before
    public void setUp() {
        TurnstileController controllerSpoof = new TurnstileController() {
            @Override
            public void lock() {
                lockCalled = true;
            }

            @Override
            public void unlock() {
                unlockCalled = true;
            }

            @Override
            public void thankyou() {
                thankyouCalled = true;
            }

            @Override
            public void alarm() {
                alarmCalled = true;
            }
        };

        t = new Turnstile(controllerSpoof);
    }

    @Test
    public void testInitialConditions() {
        Assert.assertEquals(Turnstile.LOCKED, t.state);
    }

    @Test
    public void testCoinInLockedState() {
        t.state = Turnstile.LOCKED;
        t.event(Turnstile.COIN);
        Assert.assertEquals(Turnstile.UNLOCKED, t.state);
        assert(unlockCalled);
    }

    @Test
    public void testCoinInUnlockedState() {
        t.state = Turnstile.UNLOCKED;
        t.event(Turnstile.COIN);
        Assert.assertEquals(Turnstile.UNLOCKED, t.state);
        assert(thankyouCalled);
    }

    @Test
    public void testPassInLockedState() {
        t.state = Turnstile.LOCKED;
        t.event(Turnstile.PASS);
        Assert.assertEquals(Turnstile.LOCKED, t.state);
        assert(alarmCalled);
    }

    @Test
    public void testPassInUnlockedState() {
        t.state = Turnstile.UNLOCKED;
        t.event(Turnstile.PASS);
        Assert.assertEquals(Turnstile.LOCKED, t.state);
        assert(lockCalled);
    }
}