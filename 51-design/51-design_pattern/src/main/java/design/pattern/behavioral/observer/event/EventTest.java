package design.pattern.behavioral.observer.event;

/**
 * 监听器模式：事件源经过事件的封装传给监听器，当事件源触发事件后，
 *            监听器接收到事件对象可以回调事件的方法。
 *
 * 观察者模式：观察者 (Observer) 相当于事件监听者，被观察者 (Observable)
 *            相当于事件源和事件，执行逻辑时通知 observer 即可触发 oberver
 *            的 update,同时可传被观察者和参数。
 *
 * 参考：https://blog.csdn.net/qq_26212909/article/details/79243053
 */
public class EventTest {

    /**
     * @param args
     */
    public static void main(String[] args) {
        Listener listener = new MyListener();
        // 注册监听者(注册观察者)
        Context.addListener(listener);
        // 模拟bundle 安装完成事件触发
        Context.sendNotification(new Event(Event.INSTALLED, new MyBundle()));
    }

    static class MyBundle {
    }
}