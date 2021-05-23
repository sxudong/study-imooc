package chapter10.monitorthreadpool;

import java.util.concurrent.ThreadPoolExecutor;

/**
 * ͨ�����õĲ��������̳߳�
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
