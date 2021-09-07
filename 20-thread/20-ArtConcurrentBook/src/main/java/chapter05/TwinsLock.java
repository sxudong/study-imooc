package chapter05;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.AbstractQueuedSynchronizer;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;

/**
 * 5.2.2 队列同步器的实现分析
 * 5-10 自定义同步组件——TwinsLock
 */
public class TwinsLock implements Lock {
    private final Sync sync = new Sync(2);

    /**
     * 自定义的同步器
     */
    private static final class Sync extends AbstractQueuedSynchronizer {
        private static final long serialVersionUID = -7889272986162341211L;

        Sync(int count) {
            if (count <= 0) {
                throw new IllegalArgumentException("count must large than zero.");
            }
            setState(count);
        }

        /**
         * CAS修改同步成功后的状态
         * @param reduceCount
         * @return 返回值 >= 0 时，当前线程获取到同步状态
         */
        @Override
        public int tryAcquireShared(int reduceCount) {
            for (;;) {
                int current = getState();
                int newCount = current - reduceCount;
                // 先计算获取后的同步状态,CAS确保状态的正确设置
                if (newCount < 0 || compareAndSetState(current, newCount)) {
                    return newCount;
                }
            }
        }

        /**
         * CAS修改释放后的状态
         * @param returnCount
         * @return
         */
        @Override
        public boolean tryReleaseShared(int returnCount) {
            for (;;) {
                int current = getState();
                int newCount = current + returnCount;
                // 先计算获取后的同步状态,CAS确保状态的正确设置
                if (compareAndSetState(current, newCount)) {
                    return true;
                }
            }
        }

        final ConditionObject newCondition() {
            return new ConditionObject();
        }
    }

    // 阻塞性获取锁(获取到锁的线程再次获取锁会被自已阻塞，属于不可重入锁)
    public void lock() {
        sync.acquireShared(1);
    }

    // 释放锁
    public void unlock() {
        sync.releaseShared(1);
    }

    public void lockInterruptibly() throws InterruptedException {
        sync.acquireSharedInterruptibly(1);
    }

    public boolean tryLock() {
        return sync.tryAcquireShared(1) >= 0;
    }

    public boolean tryLock(long time, TimeUnit unit) throws InterruptedException {
        return sync.tryAcquireSharedNanos(1, unit.toNanos(time));
    }

    @Override
    public Condition newCondition() {
        return sync.newCondition();
    }
}