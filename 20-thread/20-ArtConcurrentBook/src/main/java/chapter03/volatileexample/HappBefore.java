package chapter03.volatileexample;


/**
 *
 */
public class HappBefore {
    private int a = 1;
    private volatile int b = 3;

    public void write() {
        a = 3;
        b = a;
    }

    /*
     * 我们发现会出现a=1 b=3 这就是由于前一个线程的写操作对于后一个线程的读操作不可见造成的。
     * 所以我们可以利用volatile写读建立的happens-before关系来实现。
     *我们可以给b加volatile，前一个线程下对b写入后，后一个线程在读取b时，那么b之前那所有的操作都对后一个线程可见，
     * 就不会出现a=1的情况了。
     * */
    public void read() {
        System.out.println("a=" + a + ",b=" + b);
    }

    public static void main(String[] args) {
        HappBefore before = new HappBefore();
        new Thread(() -> {
            before.write();
        }).start();
        new Thread(() -> {
            before.read();
        }).start();
    }
}
/* Output:
a=3,b=3
 */