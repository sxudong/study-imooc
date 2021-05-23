package chapter05;

import java.util.concurrent.locks.AbstractQueuedSynchronizer;

/**
 * 5.2.2 队列同步器的实现分析
 *   4.独占式超时获取同步状态
 *   https://www.zhoutao123.com/page/book/java/category/ui8wdw
 */
public class DoAcquireNanos {
    public static void main(String[] args) {
        DoAcquireNanos lock = new DoAcquireNanos();
        for (int i = 0; i < 10; i++) {
            Thread thread =
                    new Thread(
                            () -> {
                                Thread currentThread = Thread.currentThread();
                                String threadName = currentThread.getName();
                                boolean locked = lock.tryLock();
                                if (locked) {
                                    System.out.println(threadName + "\t 获取锁成功");
                                    lock.tryRelease();
                                } else {
                                    System.out.println(threadName + "\t 获取锁失败");
                                }
                            });

            thread.setName("线程" + i);
            thread.start();
        }
    }

    private void tryRelease() {
        sync.release(1);
    }

    private final Sync sync = new Sync();

    public boolean tryLock() {
        try {
            return sync.tryAcquireNanos(1, 1000L);
        } catch (InterruptedException e) {
            return false;
        }
    }

    //自定义同步器
    public static class Sync extends AbstractQueuedSynchronizer {

        @Override
        protected boolean tryAcquire(int arg) {
            return getState() == 0 && compareAndSetState(0, arg);
        }

        @Override
        protected boolean tryRelease(int arg) {
            int current = getState();
            if (current < arg) {
                throw new IllegalMonitorStateException();
            }

            int newState = current - arg;
            compareAndSetState(current, newState);
            return true;
        }
    }
}
/* Output:
线程0	 获取锁成功
线程1	 获取锁失败
线程2	 获取锁失败
线程3	 获取锁成功
线程4	 获取锁成功
线程5	 获取锁成功
线程6	 获取锁成功
线程7	 获取锁失败
线程9	 获取锁成功
线程8	 获取锁成功
 */