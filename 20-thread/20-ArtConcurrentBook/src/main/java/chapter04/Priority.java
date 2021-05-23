package chapter04;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-2
 * 4.1.3 线程优先级
 *
 * 线程优先级不能作为程序正确性的依赖，因为操作系统可以完全不用理会Java
 * 线程对于优先级的设定。
 */
public class Priority {
    private static volatile boolean notStart = true;
    private static volatile boolean notEnd   = true;

    public static void main(String[] args) throws Exception {
        List<Job> jobs = new ArrayList<Job>();
        for (int i = 0; i < 10; i++) {
            int priority = i < 5 ? Thread.MIN_PRIORITY : Thread.MAX_PRIORITY;
            Job job = new Job(priority);
            jobs.add(job);
            Thread thread = new Thread(job, "Thread:" + i);
            thread.setPriority(priority);
            thread.start();
        }
        notStart = false;
//        Thread.currentThread().setPriority(8);
//        System.out.println("done.");
        TimeUnit.SECONDS.sleep(10);
        notEnd = false;

        for (Job job : jobs) {
            System.out.println("Job Priority : " + job.priority + ", Count : " + job.jobCount);
        }

    }

    static class Job implements Runnable {
        private int  priority;
        private long jobCount;

        public Job(int priority) {
            this.priority = priority;
        }

        @Override
        public void run() {
            while (notStart) {
                Thread.yield();
            }
            while (notEnd) {
                Thread.yield();
                jobCount++;
            }
        }
    }
}
/* 从输出来看，我的电脑对优先级还是比较明显的：
Job Priority : 1, Count : 235475
Job Priority : 1, Count : 235406
Job Priority : 1, Count : 235347
Job Priority : 1, Count : 235364
Job Priority : 1, Count : 235350
Job Priority : 10, Count : 3069197
Job Priority : 10, Count : 3070186
Job Priority : 10, Count : 3065682
Job Priority : 10, Count : 3069860
Job Priority : 10, Count : 3065396
 */