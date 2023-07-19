package observer.v4;

import java.util.Iterator;
import java.util.Vector;

/**
 * 程序24.24 P273
 */
public class Subject { // 被观察者（钟）
    private Vector itsObservers = new Vector();

    protected void notifyObserver() {
        Iterator i = itsObservers.iterator();
        while (i.hasNext()) {
            Observer observer = (Observer) i.next();
            observer.update();
        }
    }

    public void registerObserver(Observer observer) {
        itsObservers.add(observer);
    }
}
