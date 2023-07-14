package state.v2;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;


public class TurnstileTest {
    private Turnstile turnstile;
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

        turnstile = new Turnstile(controllerSpoof);
    }

    @Test
    public void testCoinInLockedState() {
        turnstile.coin();
        Assert.assertEquals(UnlockedTurnstileState.class.getName(), turnstile.getCurrentState().getClass().getName());
        assert(unlockCalled);
    }

    @Test
    public void testCoinInUnlockedState()  {
        turnstile.coin(); // put in Unlocked state
        turnstile.coin();
        Assert.assertEquals(UnlockedTurnstileState.class.getName(), turnstile.getCurrentState().getClass().getName());
        assert(thankyouCalled);
    }

    @Test
    public void testPassInLockedState() {
        turnstile.pass();
        Assert.assertEquals(LockedTurnstileState.class.getName(), turnstile.getCurrentState().getClass().getName());
        assert(alarmCalled);
    }

    @Test
    public void testPassInUnlockedState() {
        turnstile.coin(); // unlock
        turnstile.pass();
        Assert.assertEquals(LockedTurnstileState.class.getName(), turnstile.getCurrentState().getClass().getName());
        assert(lockCalled);
    }
}
