package state.v1;

public class Turnstile {
    // Status
    public static final int LOCKED = 0;
    public static final int UNLOCKED = 1;
    // Events
    public static final int COIN = 0;
    public static final int PASS = 1;
    private TurnstileController turnstileController;
    public int state = LOCKED;

    public Turnstile(TurnstileController action) {
        turnstileController = action;
    }

    public void event(int event) {
        switch (state) {
            case LOCKED:
                switch (event) {
                    case COIN:
                        state = UNLOCKED;
                        turnstileController.unlock();
                        break;
                    case PASS:
                        turnstileController.alarm();
                        break;
                }
                break;
            case UNLOCKED:
                switch (event) {
                    case COIN:
                        turnstileController.thankyou();
                        break;
                    case PASS:
                        state = LOCKED;
                        turnstileController.lock();
                        break;
                }
                break;
        }
    }
}
