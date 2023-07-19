package observer.v4;


/**
 * 程序24.27 P274
 */
public class MockTimeSink implements Observer {
    private int itsHours;
    private int itsMinutes;
    private int itsSeconds;
    private TimeSource itsSource;

    public MockTimeSink(TimeSource source) {
        this.itsSource = source;
    }

    @Override
    public void update() {
        this.itsHours = itsSource.getHours();
        this.itsMinutes = itsSource.getMinutes();
        this.itsSeconds = itsSource.getSeconds();
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