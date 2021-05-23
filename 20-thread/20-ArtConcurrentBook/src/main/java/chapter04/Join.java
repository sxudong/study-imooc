package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-13
 * 4.3.5 Thread.join()的使用 —— 加入一个线程
 *
 * 例子中，创建了10个线程，编号0~9，每个线程调用前一个线程的 join()方法，也就是
 * 线程0 结束了，线程1 才能从 join() 方法中返回，而 线程0 前一个线程是 main,需
 * 要等待 main 线程结束。
 *
 * 这个例子不好理解，可能参考 TestJoin.java 。
 * 一个线程可以在其他线程上调用join()方法，其效果是等待一段时间直到第二个线程结束
 * 才继续执行。如果某个线程在另一个线程t上调用t.join()，此线程将被挂起，直到目标
 * 线程t结束才恢复。
 *
 * java.lang.Thread#join()
 * public final void join() throws InterruptedException {
 *     join(0);
 * }
 *
 * public final synchronized void join(long millis) throws InterruptedException {
 *     long base = System.currentTimeMillis();
 *     long now = 0;
 *
 *     if (millis < 0) {
 *         throw new IllegalArgumentException("timeout value is negative");
 *     }
 *
 *     if (millis == 0) {
 *         while (isAlive()) {
 *             //调用线程自身的wait()方法
 *             wait(0);
 *         }
 *     } else {
 *         while (isAlive()) {
 *             long delay = millis - now;
 *             if (delay <= 0) {
 *                 break;
 *             }
 *             //调用线程自身的wait()方法
 *             wait(delay);
 *             now = System.currentTimeMillis() - base;
 *         }
 *     }
 * }
 */
public class Join {
    public static void main(String[] args) throws Exception {
        Thread previous = Thread.currentThread();
        //创建10个线程
        for (int i = 0; i < 10; i++) {
            // 每个线程拥有前一个线程的引用，需要等待前一个线程终止，才能从等待中返回
            Thread thread = new Thread(new Domino(previous), String.valueOf(i));
            thread.start();
            previous = thread; //当前创建的线程赋值给pervious变量，传给下一个线程
        }

        TimeUnit.SECONDS.sleep(5);
        System.out.println(Thread.currentThread().getName() + " terminate.");
    }

    static class Domino implements Runnable {
        private Thread thread;

        public Domino(Thread thread) {
            this.thread = thread;
        }

        @Override
        public void run() {
            try {
                thread.join(); //除了main方法，其它的线程都是运行完之后才进来，没什么要执行的很快就返回了。
            } catch (InterruptedException e) {
            }
            System.out.println(Thread.currentThread().getName() + " terminate.");
        }
    }
}
/* Output:
main terminate.
0 terminate.
1 terminate.
2 terminate.
3 terminate.
4 terminate.
5 terminate.
6 terminate.
7 terminate.
8 terminate.
9 terminate.
 */
