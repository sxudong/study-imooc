package design.pattern.behavioral.observer.event;

import java.util.ArrayList;
import java.util.List;

/**
 * 被观察者
 * 事件源: 提供订阅与取消监听者的方法，并负责维护监听者列表，发送事件给监听者
 */
public class Context {
    // 保存监听者
    private static List<Listener> list = new ArrayList<Listener>();

    public static void addListener(Listener listener) {
        list.add(listener);
    }

    public static void removeListener(Listener listener) {
        list.remove(listener);
    }

    // 当事件源对象上发生操作时，将会调用事件监听器的一个方法，
    // 并在调用该方法时把事件对象传递过去。
    public static void sendNotification(Event event) {
        for (Listener listener : list) {
            listener.onChange(event);
        }
    }
}  