package observer.v4;

/**
 * 程序24.21 P271
 */
//public class MockTimeSource implements TimeSource {
//    // 使用委托方法
//    private TimeSourceImplmentation tsImp = new TimeSourceImplmentation();
//
//    @Override
//    public void registerObserver(ClockObserver observer) {
//        tsImp.registerObserver(observer);
//    }
//
//    public void setTime(int hours, int minutes, int seconds) {
//        tsImp.notify(hours, minutes, seconds);
//    }
//}

/**
 * 程序24.26 P274
 */
public class MockTimeSource extends Subject implements TimeSource {
    private int itsHours;
    private int itsMinutes;
    private int itsSeconds;

    public void setTime(int hours, int minutes, int seconds) {
        this.itsHours = hours;
        this.itsMinutes = minutes;
        this.itsSeconds = seconds;
        notifyObserver();
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