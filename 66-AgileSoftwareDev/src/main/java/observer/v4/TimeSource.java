package observer.v4;

/**
 * 程序24.19 P270
 */
//public interface TimeSource {
//    void registerObserver(ClockObserver observer);
//}

/**
 * 程序24.25 P273
 */
public interface TimeSource {
    int getHours();
    int getMinutes();
    int getSeconds();
}
