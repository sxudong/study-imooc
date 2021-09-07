package chapter10.monitorthreadpool;

import java.util.concurrent.ThreadPoolExecutor;

/**
 * 通过设置的参数创建线程池
 */
public interface ITestThreadPoolExecutorService {

    ThreadPoolExecutor createThreadPoolExecutor();

    int getCorePoolSize();

    void setCorePoolSize(int corePoolSize);

    int getMaxPoolSize();

    void setMaxPoolSize(int maxPoolSize);

    long getKeepAliveTime();

    void setKeepAliveTime(long keepAliveTime);

}
