package state.v4;

/**
 * 程序29.10 P378
 */
public class TurnstileFSM extends Turnstile{
    private TurnstileController controller;
    TurnstileFSM(TurnstileController controller) {
        this.controller = controller;
    }

    public void lock() {
        controller.lock();
    }

    public void unlock() {
        controller.unlock();
    }

    public void thankyou() {
        controller.thankyou();
    }

    public void alarm() {
        controller.alarm();
    }
}
