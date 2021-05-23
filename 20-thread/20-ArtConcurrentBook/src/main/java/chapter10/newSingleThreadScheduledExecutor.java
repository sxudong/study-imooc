package chapter10;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 10.3 ScheduledThreadPoolExecutor详解
 *
 * ScheduledFuture<?> scheduleWithFixedDelay(Runnable var1, long var2, long var4, TimeUnit var6);
 * 参数解释：    
 * var1   command：执行线程
 * var2   initialDelay：初始化延时（程序运行后N秒开始执行线程）
 * var4   period：前一次执行结束到下一次执行开始的间隔时间（间隔执行延迟时间），从"上一次任务运行结束"开始计时
 * var6   unit：计时单位
 *
 *
 * ScheduledFuture<?> scheduleAtFixedRate(Runnable var1, long var2, long var4, TimeUnit var6);
 * 参数解释：
 * var1   command：执行线程
 * var2   initialDelay：初始化延时
 * var4   period：两次开始执行最小间隔时间，从"上一个任务开始运行”就开始计时
 * var6   unit：计时单位
 */
public class newSingleThreadScheduledExecutor {

    public static void main(String[] args) {

        ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();

//        executorService.schedule(new Runnable() {
//            @Override
//            public void run() {
//                System.out.println("schedule run");
//            }
//        }, 3, TimeUnit.SECONDS);  // 延迟3秒钟执行

        executorService.scheduleWithFixedDelay(new Runnable() {
            @Override
            public void run() {
                System.err.println("schedule run");
            }
        }, 1, 3, TimeUnit.SECONDS);  // 延迟1秒，每隔3秒执行
//        executorService.shutdown();

        // 演示：Timer延迟类
        // Timer只是充当了一个执行者的角色，真正的任务逻辑是通过一个叫做 TimerTask 的抽象类完成的
        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                System.err.println("timer run");
            }
        }, new Date(), 5 * 1000); // 每次间隔5秒执行一次
    }
}
/* Output:
timer run
schedule run
schedule run
timer run
schedule run
schedule run
timer run
......
 */