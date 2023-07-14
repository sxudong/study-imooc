package state.v3;

import java.util.Vector;

/**
 * 程序29.12 P382
 */
public class Turnstile {
    // Status
    public static final int LOCKED = 0;
    public static final int UNLOCKED = 1;
    // Events
    public static final int COIN = 0;
    public static final int PASS = 1;
    public int state = LOCKED;
    private TurnstileController turnstileController;
    private Vector transitions = new Vector();

    public Turnstile(TurnstileController action) {
        this.turnstileController = action;
        addTransition(LOCKED, COIN, UNLOCKED, unlock());
        addTransition(LOCKED, PASS, LOCKED, alarm());
        addTransition(UNLOCKED, COIN, UNLOCKED, thankyou());
        addTransition(UNLOCKED, PASS, LOCKED, lock());
    }

    private void addTransition(int currentState, int event, int newState, Action action) {
        transitions.add(new Transition(currentState, event, newState, action));
    }

    private Action lock() {
        return new Action() {
            public void execute() {
                doLock();
            }
        };
    }

    private Action thankyou() {
        return new Action() {
            public void execute() {
                doThankyou();
            }
        };
    }

    private Action alarm() {
        return new Action() {
            public void execute() {
                doAlarm();
            }
        };
    }

    private Action unlock() {
        return new Action() {
            public void execute() {
                doUnlock();
            }
        };
    }

    private void doLock() {
        turnstileController.lock();
    }

    private void doUnlock() {
        turnstileController.unlock();
    }

    private void doThankyou() {
        turnstileController.thankyou();
    }

    private void doAlarm() {
        turnstileController.alarm();
    }

    public void event(int event) {
        for (int i = 0; i < transitions.size(); i++) {
            Transition transition = (Transition) transitions.elementAt(i);
            if (state == transition.currentState && event == transition.event) {
                state = transition.newState;
                transition.action.execute();
            }
        }
    }
}
