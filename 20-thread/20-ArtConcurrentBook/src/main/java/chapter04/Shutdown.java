package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-9
 * 4.2.5 安全地终止线程
 * 优雅的关闭线程的2种方式：
 *   1.通过interrupt()方法
 *   2.复用一个boolean变量来控制是否需要停止任务并终止该线程
 * 在例子中，创建了一个线程 CountThread，它不断地进行变量累加，而
 * 主线程尝试对其进行"中断操作"和"停止操作"。
 */
public class Shutdown {
    public static void main(String[] args) throws Exception {
        Runner one = new Runner();
        Thread countThread = new Thread(one, "CountThread");
        countThread.start();
        // 睡眠1秒，main线程对CountThread进行中断，使CountThread能够感知中断而结束
        TimeUnit.SECONDS.sleep(1);
        countThread.interrupt();

        Runner two = new Runner();
        countThread = new Thread(two, "CountThread");
        countThread.start();
        System.out.println(Thread.activeCount()); //当前线程的线程组中活动线程的数目
        // 睡眠1秒，main线程对Runner two进行取消，使CountThread能够感知on为false而结束
        TimeUnit.SECONDS.sleep(1);
        two.cancel();
        TimeUnit.SECONDS.sleep(3);
        System.out.println(Thread.activeCount());
    }

    private static class Runner implements Runnable {
        private long             i;
        private volatile boolean on = true;

        @Override
        public void run() {
            //只要没取消和中断就累加
            while (on && !Thread.currentThread().isInterrupted()) {
                i++;
            }
            System.out.println("Count i = " + i);
        } //run()方法之后将会进入“终止状态”

        public void cancel() {
            on = false;
        }
    }
}
/* main线程通过中断操作和cancel()方法均可使CountThread得以终止:
4
Count i = 578262417
Count i = 566090059
2
 */