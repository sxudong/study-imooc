package chapter13;

import junit.framework.TestCase;

/**
 * 《代码整洁之道》代码清单 A-2 P318
 * 关于线程安全可以看 20-thread
 */
public class ClassWithThreadingProblemTest extends TestCase{

    public void testTwoThreadsShouldFailEventually() throws InterruptedException {
        final ClassWithThreadingProblem classWithThreadingProblem = new ClassWithThreadingProblem();

        Runnable runnable = new Runnable() {
            public void run() {
                classWithThreadingProblem.takeNextId();
            }
        };

        // 要真正的监测到问题，需要将循环数量设置到 100 万次以上
        for (int i = 0; i < 50000; ++i) {
            int startintId = classWithThreadingProblem.lastId();
            int expectedResult = 2 + startintId;

            Thread t1 = new Thread(runnable);
            Thread t2 = new Thread(runnable);
            t1.start();
            t2.start();
            t1.join();
            t2.join();

            int endingId = classWithThreadingProblem.lastId();
            if (endingId != expectedResult)
                return; // 如果与预期结果不一致，程序结束。如果一致继续循环。
        }

        // 应该暴露一个线程问题，但它没有。执行到这行代码，则证明没有测试到并发问题
        fail("Should have exposed a threading issue but it dit not.");
    }
}