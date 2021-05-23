package chapter04;

import java.sql.Connection;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 代码清单 4-18
 * 4.4.2 一个简单的数据库连接池示例   等待超时模式
 *
 * 通过一个示例来测试简易数据库连接池的工作情况，模拟客户端ConnectionRunner获
 * 取、使用、最后释放连接的过程，当它使用时连接将会增加获取到连接的数量，反之，
 * 将会增加未获取到连接的数量。
 */
public class ConnectionPoolTest {
    static ConnectionPool pool  = new ConnectionPool(10);
    // 保证所有ConnectionRunner能够同时开始
    static CountDownLatch start = new CountDownLatch(1);
    // main线程将会等待所有ConnectionRunner结束后才能继续执行
    static CountDownLatch end;

    public static void main(String[] args) throws Exception {
        // 线程数量，可以线程数量进行观察
        int threadCount = 50;
        end = new CountDownLatch(threadCount);
        int count = 20;
        AtomicInteger got = new AtomicInteger();
        AtomicInteger notGot = new AtomicInteger();

        //创建50个线程竞争获取10个连接
        for (int i = 0; i < threadCount; i++) {
            Thread thread = new Thread(new ConnetionRunner(count, got, notGot), "ConnectionRunnerThread");
            thread.start();
        }

        start.countDown(); //start只有1，自减1，通知所有线程一起开始
        end.await(); //等待执行完毕返回
        System.out.println("total invoke: " + (threadCount * count));
        System.out.println("got connection:  " + got);
        System.out.println("not got connection " + notGot);
    }

    static class ConnetionRunner implements Runnable {
        int count; //获取连接次数
        AtomicInteger got; //获取到的次数
        AtomicInteger notGot; //未获取到的次数

        public ConnetionRunner(int count, AtomicInteger got, AtomicInteger notGot) {
            this.count = count;
            this.got = got;
            this.notGot = notGot;
        }

        @Override
        public void run() {
            try {
                //使用 CountDownLatch 来确保ConnectionRunnerThread能够同时开始执行
                //调用await()方法的线程会被挂起，它会等待直到count值为0才继续执行
                start.await();
            } catch (Exception ex) {
            }
            while (count > 0) {
                try {
                    // 从线程池中获取连接，如果1000ms内无法获取到，将会返回null
                    // 分别统计连接获取的数量got和未获取到的数量notGot
                    Connection connection = pool.fetchConnection(1000);
                    if (connection != null) {
                        try {
                            connection.createStatement();
                            connection.commit();
                        } finally {
                            pool.releaseConnection(connection);
                            got.incrementAndGet();
                        }
                    } else {
                        notGot.incrementAndGet();
                    }
                } catch (Exception ex) {
                } finally {
                    count--;
                }
            }
            end.countDown(); //将count值减1
        }
    }
}
/* Output:
total invoke: 1000
got connection:  131
not got connection 869
 */