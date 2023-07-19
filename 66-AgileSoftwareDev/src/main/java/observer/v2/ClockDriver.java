package observer.v2;

/**
 * 程序24.8 P265
 */
public class ClockDriver implements ClockObserver {
    private TimeSink itsSink;

    public ClockDriver(TimeSource source, TimeSink sink) {
        source.setObserver(this);
        this.itsSink = sink;
    }

    @Override
    public void update(int hours, int minutes, int seconds) {
        itsSink.setTime(hours, minutes, seconds);
    }
}
