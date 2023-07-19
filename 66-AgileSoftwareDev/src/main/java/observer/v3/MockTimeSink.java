package observer.v3;

/**
 * 程序24.12 P267
 */
public class MockTimeSink implements ClockObserver {
    private int itsHours;
    private int itsMinutes;
    private int itsSeconds;

    @Override
    public void update(int hours, int minutes, int seconds) {
        this.itsHours = hours;
        this.itsMinutes = minutes;
        this.itsSeconds = seconds;
    }

    public int getHours() {
        return itsHours;
    }

    public int getMinutes() {
        return itsMinutes;
    }

    public int getSeconds() {
        return itsSeconds;
    }

}