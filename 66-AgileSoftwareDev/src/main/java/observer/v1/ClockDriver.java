package observer.v1;

/**
 * 程序24.4 P264
 */
public class ClockDriver {
    private TimeSink itsSink;

    public ClockDriver(TimeSource source, TimeSink sink) {
        source.setDriver(this);
        this.itsSink = sink;
    }

    public void update(int hours, int minutes, int seconds) {
        itsSink.setTime(hours, minutes, seconds);
    }
}
