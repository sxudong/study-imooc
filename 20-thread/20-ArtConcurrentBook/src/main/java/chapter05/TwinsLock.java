package chapter05;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.AbstractQueuedSynchronizer;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;

/**
 * 5.2.2 ����ͬ������ʵ�ַ���
 * 5-10 �Զ���ͬ���������TwinsLock
 */
public class TwinsLock implements Lock {
    private final Sync sync = new Sync(2);

    /**
     * �Զ����ͬ����
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
         * CAS�޸�ͬ���ɹ����״̬
         * @param reduceCount
         * @return ����ֵ >= 0 ʱ����ǰ�̻߳�ȡ��ͬ��״̬
         */
        @Override
        public int tryAcquireShared(int reduceCount) {
            for (;;) {
                int current = getState();
                int newCount = current - reduceCount;
                // �ȼ����ȡ���ͬ��״̬,CASȷ��״̬����ȷ����
                if (newCount < 0 || compareAndSetState(current, newCount)) {
                    return newCount;
                }
            }
        }

        /**
         * CAS�޸��ͷź��״̬
         * @param returnCount
         * @return
         */
        @Override
        public boolean tryReleaseShared(int returnCount) {
            for (;;) {
                int current = getState();
                int newCount = current + returnCount;
                // �ȼ����ȡ���ͬ��״̬,CASȷ��״̬����ȷ����
                if (compareAndSetState(current, newCount)) {
                    return true;
                }
            }
        }

        final ConditionObject newCondition() {
            return new ConditionObject();
        }
    }

    // �����Ի�ȡ��(��ȡ�������߳��ٴλ�ȡ���ᱻ�������������ڲ���������)
    public void lock() {
        sync.acquireShared(1);
    }

    // �ͷ���
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
