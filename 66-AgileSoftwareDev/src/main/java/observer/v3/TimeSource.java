package observer.v3;

import java.util.Iterator;
import java.util.Vector;


/**
 * 程序24.16 P269
 */
public class TimeSource {
    private Vector itsObserver = new Vector(); //观察者

    public void notify(int hours, int minutes, int seconds) {
        Iterator i = itsObserver.iterator();
        while (i.hasNext()) {
            ClockObserver observer = (ClockObserver) i.next();
            observer.update(hours, minutes, seconds);
        }
    }

    public void registerObserver(ClockObserver observer) {
        this.itsObserver.add(observer);
    }
}