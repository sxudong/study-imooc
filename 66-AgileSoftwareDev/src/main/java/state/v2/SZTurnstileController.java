package state.v2;

public class SZTurnstileController implements TurnstileController{
    private Turnstile turnstile;
    private boolean lockCalled = false;
    private boolean unlockCalled = false;
    private boolean thankyouCalled = false;
    private boolean alarmCalled = false;

    public Turnstile getTurnstile() {
        return turnstile;
    }

    public void setTurnstile(Turnstile turnstile) {
        this.turnstile = turnstile;
    }

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

}
