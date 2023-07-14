package state.v2;

/**
 * 程序29.6 P374
 */
public class UnlockedTurnstileState implements TurnstileState{
    @Override
    public void coin(Turnstile t) {
        t.thankyou();
    }

    @Override
    public void pass(Turnstile t) {
        t.setLocked();
        t.lock();
    }
}
