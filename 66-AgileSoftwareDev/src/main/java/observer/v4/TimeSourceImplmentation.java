package observer.v4;

import java.util.Iterator;
import java.util.Vector;

/**
 * 程序24.20 P270
 */
public class TimeSourceImplmentation {
    private Vector itsObservers = new Vector();

    protected void notify(int hours, int minutes, int seconds) {
        Iterator i = itsObservers.iterator();
        while (i.hasNext()) {
            ClockObserver observer = (ClockObserver) i.next();
            observer.update(hours, minutes, seconds);
        }
    }

    public void registerObserver(ClockObserver observer) {
        itsObservers.add(observer);
    }

}
