package state.v1;

public interface TurnstileController {
    void lock();
    void unlock();
    void thankyou();
    void alarm();
}
