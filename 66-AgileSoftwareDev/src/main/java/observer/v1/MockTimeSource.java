package observer.v1;

/**
 * 程序24.5 P264
 */
public class MockTimeSource implements TimeSource {
    private ClockDriver itsDriver;

    @Override
    public void setDriver(ClockDriver driver) {
        this.itsDriver = driver;
    }

    public void setTime(int hours, int minutes, int seconds) {
        itsDriver.update(hours, minutes, seconds);
    }
}
