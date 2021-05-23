package chapter04;

import java.sql.Connection;
import java.util.LinkedList;

/**
 * 代码清单 4-16
 * 4.4.2 一个简单的数据库连接池示例
 *
 * 在示例中模拟从连接池中获取、使用和释放连接的过程，而客户端获取连接的过程被设定为等
 * 待超时的模式，也就是在1000毫秒内如果无法获取到可用连接，将会返回给客户端一个null。
 * 设定连接池的大小为10个，然后通过调节客户端的线程数来模拟无法获取连接的场景。
 */
public class ConnectionPool {
    //通过一个双向队列来维护连接
    private LinkedList<Connection> pool = new LinkedList<Connection>();

    /**
     * 通过构造函数初始化连接的最大上限
     * @param initialSize 连接的最大上限
     */
    public ConnectionPool(int initialSize) {
        if (initialSize > 0) {
            for (int i = 0; i < initialSize; i++) {
                pool.addLast(ConnectionDriver.createConnection());
            }
        }
    }

    //释放连接,将"连接"放回线程池
    public void releaseConnection(Connection connection) {
        if (connection != null) {
            synchronized (pool) {
                // 添加后需要进行通知，这样其他消费者能够感知到链接池中已经归还了一个链接
                pool.addLast(connection);
                pool.notifyAll();
            }
        }
    }

    // 在mills内无法获取到连接，将会返回null
    public Connection fetchConnection(long mills) throws InterruptedException {
        synchronized (pool) {
            // 完全超时
            if (mills <= 0) {
                while (pool.isEmpty()) {
                    pool.wait();
                }

                return pool.removeFirst();
            } else {
                long future = System.nanoTime() + mills;
                long remaining = mills;
                while (pool.isEmpty() && remaining > 0) {
                    pool.wait(remaining);
                    remaining = future - System.nanoTime();
                }

                Connection result = null;
                if (!pool.isEmpty()) {
                    result = pool.removeFirst();
                }
                return result;
            }
        }
    }
}
