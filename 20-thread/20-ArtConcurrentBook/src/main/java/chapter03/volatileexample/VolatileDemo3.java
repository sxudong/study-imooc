package chapter03.volatileexample;

/**
 * 3、禁止指令重排
 *
 * 重排序：为了提高性能，编译器和处理器会对既定的代码执行顺序进行指令重排序。
 * 在不改变程序执行结果的前提下，尽可能提高执行效率，JMM对底层尽量减少约束，
 * 使其能够发挥自身优势。
 *
 */
public class VolatileDemo3 {

    private static int a = 0, b = 0, i = 0, j = 0;

    /**
     * 案例演示
     */
    public static void main(String[] args) throws InterruptedException {
        int count = 0;
        while (true) {
            count++;
            a = 0;
            b = 0;
            i = 0;
            j = 0;
            Thread thread1 = new Thread(() -> {
                a = 1;
                i = b; //0
            });
            Thread thread2 = new Thread(() -> {
                b = 1;
                j = a; //1
            });
            thread1.start();
            thread2.start();
            thread1.join();
            thread2.join();
            System.out.println("第" + count + "次" + "i=" + i + "," + "j=" + j);
            if (i == 0 && j == 0) {
                //i=0,j=0就发生了指令排序，发现加了 volatile 之后就不会发生这种情况
                break;
            }
        }
    }
}
/* Output:
......
第1348次i=0,j=0
 */