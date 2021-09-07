package chapter10.monitorthreadpool;

/**
 * 这个类维护了线程池和线程池监控服务
 */
/*
@Component
public class ThreadPoolExecutorStarter {

    private Logger logger = LoggerFactory.getLogger(ThreadPoolExecutorStarter.class);

    @Autowired
    private ITestThreadPoolExecutorService threadPoolExecutorService;

    @Autowired
    private IThreadPoolMonitorService monitorService;

    public void start() {
        ThreadPoolExecutor executor = threadPoolExecutorService.createThreadPoolExecutor();
        executor.allowCoreThreadTimeOut(true);

        monitorService.setExecutor(executor);
        monitorService.setMonitoringPeriod(3);
        Thread monitor = new Thread(monitorService);
        monitor.start();

        for (int i = 1; i <= 10; i++) {
            executor.execute(new TestTask("task" + i));
        }

        try {
            Thread.sleep(10000);
        } catch (InterruptedException e) {
            logger.error(e.getMessage());
        }

        for (int i = 1; i <= 5; i++) {
            executor.execute(new TestTask("task" + i));
        }

        executor.shutdown();
    }
}
*/