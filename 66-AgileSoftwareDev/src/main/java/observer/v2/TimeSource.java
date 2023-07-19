package observer.v2;

/**
 * 程序24.9 P265
 * 整理它，我不喜欢从 TimeSource 到 ClockDriver 的依赖关系，
 * 因为我希望 TimeSource 接口可以被任何对象使用，不仅仅是 ClockDriver
 * 对象。通过创建一个 TimeSource 可以使用，而 ClockDriver 可以
 * 继承的接口，就可以修改这个问题，我们称这个接口为 ClockObserver。
 */
public interface TimeSource {
    void setObserver(ClockObserver observer);
}
