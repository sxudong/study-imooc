package observer.v1;

/**
 * 第24章 OBSERVER模式
 * 程序24.2 P263
 */
public interface TimeSource {
    void setDriver(ClockDriver driver);
}
