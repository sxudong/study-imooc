package observer.v1;

/**
 * 程序24.6 P264
 */
public class MockTimeSink implements TimeSink {
    private int itsHours;
    private int itsMinutes;
    private int itsSeconds;

    @Override
    public void setTime(int hours, int minutes, int seconds) {
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
