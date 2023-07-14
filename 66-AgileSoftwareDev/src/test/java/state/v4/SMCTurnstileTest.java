package state.v4;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * 程序29.15 P387
 */
public class SMCTurnstileTest {

    private TurnstileFSM t;
    private boolean lockCalled = false;
    private boolean unlockCalled = false;
    private boolean thankyouCalled = false;
    private boolean alarmCalled = false;

    @Before
    public void setUp() {
        TurnstileController controllerSpoof = new TurnstileController(){
            public void lock(){lockCalled = true;}
            public void unlock(){unlockCalled = true;}
            public void thankyou(){thankyouCalled = true;}
            public void alarm(){alarmCalled = true;}
        };

        t = new TurnstileFSM(controllerSpoof);
    }

    @Test
    public void testInitialConditions() {
        Assert.assertEquals("Locked", t.getCurrentStateName());
    }

    @Test
    public void testCoinInLockedState() throws FSMError {
        t.coin();
        Assert.assertEquals("Unlocked", t.getCurrentStateName());
        assert(unlockCalled);
    }

    @Test
    public void testCoinInUnlockedState() throws FSMError {
        t.coin(); // put in Unlocked state
        t.coin();
        Assert.assertEquals("Unlocked", t.getCurrentStateName());
        assert(thankyouCalled);
    }

    @Test
    public void testPassInLockedState() throws FSMError {
        t.pass();
        Assert.assertEquals("Locked", t.getCurrentStateName());
        assert(alarmCalled);
    }

    @Test
    public void testPassInUnlockedState() throws FSMError {
        t.coin(); // unlock
        t.pass();
        Assert.assertEquals("Locked", t.getCurrentStateName());
        assert(lockCalled);
    }
}
