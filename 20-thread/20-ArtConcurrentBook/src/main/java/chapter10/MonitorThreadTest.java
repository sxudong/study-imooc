package chapter10;

import java.util.concurrent.*;

/**
 * 9.2 线程池的使用和监控
 *
 * 如果在系统中大量使用线程池，则有必要对线程池进行监控，方便在出现问题时，可以根
 * 据线程池的使用状况快速定位问题。可以通过线程池提供的参数进行监控，在监控线程池的
 * 时候可以使用以下属性。
 *  ·getTaskCount：线程池需要执行的任务数量。
 *  ·completedTaskCount：线程池在运行过程中已完成的任务数量，小于或等于taskCount。
 *  ·largestPoolSize：线程池里曾经创建过的最大线程数量。通过这个数据可以知道线程池是
 *   否曾经满过。如该数值等于线程池的最大大小，则表示线程池曾经满过。
 *  ·getPoolSize：线程池的线程数量。如果线程池不销毁的话，线程池里的线程不会自动销
 *   毁，所以这个大小只增不减。
 *  ·getActiveCount：获取活动的线程数。
 *
 * 通过扩展线程池进行监控。可以通过继承线程池来自定义线程池，重写线程池的
 * beforeExecute、afterExecute和terminated方法，也可以在任务执行前、执行后和线程池关闭前执
 * 行一些代码来进行监控。例如，监控任务的平均执行时间、最大执行时间和最小执行时间等。
 * 这几个方法在线程池里是空方法。
 */
public class MonitorThreadTest {

    public static void main(String[] args) {
        ExecutorService executorService = Executors.newCachedThreadPool();

        for (int i = 0; i < 10; i++) {
            final int index = i;
            // executorService.execute(() -> log.info("task:{}", index));
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    System.out.println("task: " + index);
                }
            });
        }
        executorService.shutdown();
        ThreadPoolExecutor threadPoolExecutor = (ThreadPoolExecutor) executorService;
        System.out.println("线程总数: " + threadPoolExecutor.getTaskCount());
    }
}
/* Output:
线程总数: 10
task: 0
task: 1
task: 2
task: 3
task: 4
task: 5
task: 6
task: 7
task: 8
task: 9
 */