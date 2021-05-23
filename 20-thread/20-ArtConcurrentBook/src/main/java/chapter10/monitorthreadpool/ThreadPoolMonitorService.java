package chapter10.monitorthreadpool;

/**
 * �̳߳ؽӿ�
 */
/*
@Data
public class ThreadPoolMonitorService implements IThreadPoolMonitorService {

    private Logger logger = LoggerFactory.getLogger(ThreadPoolMonitorService.class);

    //ͨ��Lombokʵ��get/set
    private ThreadPoolExecutor executor;

    private long monitoringPeriod;

    @Override
    public void monitorThreadPool() {
        String buffer = "CurrentPoolSize��" + executor.getPoolSize() +
                " - CorePoolSize��" + executor.getCorePoolSize() +
                " - MaximumPoolSize��" + executor.getMaximumPoolSize() +
                " - ActiveTaskCount��" + executor.getActiveCount() +
                " - CompletedTaskCount��" + executor.getCompletedTaskCount() +
                " - TotalTaskCount��" + executor.getTaskCount() +
                " - isTerminated��" + executor.isTerminated();
        logger.debug(buffer);
    }

    @Override
    public void run() {
        try {
            while (true) {
                monitorThreadPool();
                Thread.sleep(monitoringPeriod * 1000);
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }
}
*/