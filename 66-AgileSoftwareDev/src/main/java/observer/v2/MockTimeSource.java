package observer.v2;

/**
 * 程序24.10 P265
 */
public class MockTimeSource implements TimeSource {
    private ClockObserver itsObserver; //观察者

    @Override
    public void setObserver(ClockObserver observer) {
        this.itsObserver = observer;
    }

    public void setTime(int hours, int minutes, int seconds) {
        itsObserver.update(hours, minutes, seconds);
    }
}
