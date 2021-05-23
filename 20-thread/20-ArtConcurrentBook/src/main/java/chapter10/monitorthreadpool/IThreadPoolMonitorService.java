package chapter10.monitorthreadpool;

import java.util.concurrent.ThreadPoolExecutor;

/**
 * 线程池监控接口
 */
public interface IThreadPoolMonitorService extends Runnable {

    void monitorThreadPool();

    ThreadPoolExecutor getExecutor();

    void setExecutor(ThreadPoolExecutor executor);

    long getMonitoringPeriod();

    void setMonitoringPeriod(long monitoringPeriod);

}
