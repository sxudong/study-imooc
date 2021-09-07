package chapter10.monitorthreadpool;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 线程池实现类
 */
/*
@Data //通过Lombok实现get/set
public class TestThreadPoolExecutorService implements ITestThreadPoolExecutorService {

    private int corePoolSize;
    private int maxPoolSize;
    private long keepAliveTime;
    private int queueCapacity;
    private RejectedExecutionHandler rejectedExecutionHandler;

    @Override
    public ThreadPoolExecutor createThreadPoolExecutor() {
        return new ThreadPoolExecutor(corePoolSize, maxPoolSize, keepAliveTime, TimeUnit.SECONDS, new ArrayBlockingQueue<>(getQueueCapacity()),
                getRejectedExecutionHandler());
    }

}
*/