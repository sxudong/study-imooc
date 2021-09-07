package chapter10.monitorthreadpool;

/**
 * demo启动类
 *
 * https://blog.csdn.net/wang704987562/article/details/88858852
 * 目标：创建线程池和一个监控线程，监控线程持有线程池引用，接着定时打印线程池相关信息，使用springboot创建demo。
 */
/*
@SpringBootApplication
public class DemoApplication implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Bean
    public TestRejectedExecutionHandler rejectedExecutionHandler() {
        return new TestRejectedExecutionHandler();
    }

    @Bean
    public ITestThreadPoolExecutorService threadPoolExecutorService(TestRejectedExecutionHandler rejectedExecutionHandler) {
        TestThreadPoolExecutorService executor = new TestThreadPoolExecutorService();
        executor.setCorePoolSize(1);
        executor.setMaxPoolSize(3);
        executor.setQueueCapacity(3);
        executor.setKeepAliveTime(10);
        executor.setRejectedExecutionHandler(rejectedExecutionHandler);
        return executor;
    }

    @Bean
    public IThreadPoolMonitorService monitorService() {
        ThreadPoolMonitorService monitorService = new ThreadPoolMonitorService();
        monitorService.setMonitoringPeriod(3);
        return monitorService;
    }

    @Autowired
    private ThreadPoolExecutorStarter executorStarter;

    @Override
    public void run(String... args) throws Exception {
        //线程池监控测试
        executorStarter.start();
    }
}
*/
/* Output:
00:03:11.915 logback [Thread-10] DEBUG c.e.d.s.t.ThreadPoolMonitorService - CurrentPoolSize：0 - CorePoolSize：1 - MaximumPoolSize：3 - ActiveTaskCount：0 - CompletedTaskCount：0 - TotalTaskCount：0 - isTerminated：false
00:03:11.916 logback [restartedMain] DEBUG c.e.d.s.t.TestRejectedExecutionHandler - task7: has been rejected.
00:03:11.916 logback [pool-2-thread-3] DEBUG c.e.demo.service.threadpool.TestTask - task6 is started.
00:03:11.916 logback [pool-2-thread-1] DEBUG c.e.demo.service.threadpool.TestTask - task1 is started.
00:03:11.916 logback [pool-2-thread-2] DEBUG c.e.demo.service.threadpool.TestTask - task5 is started.
00:03:11.916 logback [restartedMain] DEBUG c.e.d.s.t.TestRejectedExecutionHandler - task8: has been rejected.
00:03:11.916 logback [restartedMain] DEBUG c.e.d.s.t.TestRejectedExecutionHandler - task9: has been rejected.
00:03:11.916 logback [restartedMain] DEBUG c.e.d.s.t.TestRejectedExecutionHandler - task10: has been rejected.
00:03:12.917 logback [pool-2-thread-3] DEBUG c.e.demo.service.threadpool.TestTask - task6 is completed.
00:03:12.917 logback [pool-2-thread-1] DEBUG c.e.demo.service.threadpool.TestTask - task1 is completed.
00:03:12.917 logback [pool-2-thread-2] DEBUG c.e.demo.service.threadpool.TestTask - task5 is completed.
00:03:12.917 logback [pool-2-thread-3] DEBUG c.e.demo.service.threadpool.TestTask - task2 is started.
00:03:12.917 logback [pool-2-thread-1] DEBUG c.e.demo.service.threadpool.TestTask - task3 is started.
00:03:12.917 logback [pool-2-thread-2] DEBUG c.e.demo.service.threadpool.TestTask - task4 is started.
00:03:13.918 logback [pool-2-thread-1] DEBUG c.e.demo.service.threadpool.TestTask - task3 is completed.
00:03:13.918 logback [pool-2-thread-3] DEBUG c.e.demo.service.threadpool.TestTask - task2 is completed.
00:03:13.918 logback [pool-2-thread-2] DEBUG c.e.demo.service.threadpool.TestTask - task4 is completed.
00:03:14.915 logback [Thread-10] DEBUG c.e.d.s.t.ThreadPoolMonitorService - CurrentPoolSize：3 - CorePoolSize：1 - MaximumPoolSize：3 - ActiveTaskCount：0 - CompletedTaskCount：6 - TotalTaskCount：6 - isTerminated：false
00:03:17.916 logback [Thread-10] DEBUG c.e.d.s.t.ThreadPoolMonitorService - CurrentPoolSize：3 - CorePoolSize：1 - MaximumPoolSize：3 - ActiveTaskCount：0 - CompletedTaskCount：6 - TotalTaskCount：6 - isTerminated：false
 */