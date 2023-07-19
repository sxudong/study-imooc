package observer.v3;


/**
 * 程序24.17 P269
 */
public class MockTimeSource extends TimeSource {

    public void setTime(int hours, int minutes, int seconds) {
        notify(hours, minutes, seconds);
    }
}