package state.v2;

/**
 * 程序29.6 P374
 */
public class LockedTurnstileState implements TurnstileState{
    @Override
    public void coin(Turnstile t) {
        t.setUnlocked();
        t.unlock();
    }

    @Override
    public void pass(Turnstile t) {
        t.alarm();
    }
}
