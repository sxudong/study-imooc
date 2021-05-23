package chapter10.source;

import java.util.concurrent.*;

public class ScheduledThreadPoolExecutor {

    // ������schedule�������÷�����ָ������ָ���ӳ�ʱ�䵽��󴥷���ֻ��ִ��һ�Ρ�
    /*
    public ScheduledFuture<?> schedule(Runnable command,
                                       long delay,
                                       TimeUnit unit) {
        //����У��
        if (command == null || unit == null)
            throw new NullPointerException();
        //������һ��Ƕ�׽ṹ�����Ȱ��û��ύ�������װ��ScheduledFutureTask
        //Ȼ���ڵ���decorateTask���а�װ���÷����������û�ȥ��չ�ģ�Ĭ���Ǹ��շ���
        RunnableScheduledFuture<?> t = decorateTask(command,
                new ScheduledFutureTask<Void>(command, null,
                        triggerTime(delay, unit)));
        //��װ�������Ժ󣬾ͽ����ύ��
        delayedExecute(t);
        return t;
    }
   */

    /*
        private void delayedExecute(RunnableScheduledFuture<?> task) {
        //����̳߳��Ѿ��رգ���ʹ�þܾ����԰��ύ����ܾ���
        if (isShutdown())
            reject(task);
        else {
            //��ThreadPoolExecutor��ͬ������ֱ�Ӱ���������ӳٶ���
            super.getQueue().add(task);
            //�����ǰ״̬�޷�ִ��������ȡ��
            if (isShutdown() &&
                !canRunInCurrentRunState(task.isPeriodic()) &&
                remove(task))
                task.cancel(false);
            else
                //����������һ��worker�̣߳������ύ������û��workerȥִ��
                //ԭ����Ǹ���û����ThreadPoolExecutorһ����woker���˲ŷ������
                ensurePrestart();
        }
    }
     */

    // ��ָ����Ԫ�ز��뵽������
    /*
            public boolean offer(Runnable x) {
            //����У��
            if (x == null)
                throw new NullPointerException();
            RunnableScheduledFuture<?> e = (RunnableScheduledFuture<?>)x;
            final ReentrantLock lock = this.lock;
            lock.lock();
            try {
                //�鿴��ǰԪ��������������ڶ��г������������
                int i = size;
                if (i >= queue.length)
                    grow();
                //Ԫ��������1
                size = i + 1;
                //�����ǰ���л�û��Ԫ�أ���ֱ�Ӽ���ͷ��
                if (i == 0) {
                    queue[0] = e;
                    //��¼����
                    setIndex(e, 0);
                } else {
                    //�����������У��������ѽṹ������ͻ��������Ĵ���ʱ������
                    //����Ҫ����ִ�е��������ǰ��
                    siftUp(i, e);
                }
                //����¼����Ԫ�ؾ��Ƕ���ͷ���������������
                //1.�����û��ύ�ĵ�һ������
                //2.��������жѵ����Ժ����ڶ���ͷ
                if (queue[0] == e) {
                    //����������Ż����ã�����˵
                    leader = null;
                    //����Ԫ���Ժ󣬻���worker�߳�
                    available.signal();
                }
            } finally {
                lock.unlock();
            }
            return true;
        }
     */


    /*
    public RunnableScheduledFuture<?> take() throws InterruptedException {
        final ReentrantLock lock = this.lock;
        lock.lockInterruptibly();
        try {
            for (;;) {
                //ȡ�������е�һ��Ԫ�أ���������Ҫִ�е�����
                RunnableScheduledFuture<?> first = queue[0];
                //�������Ϊ�գ��������ȴ�����Ԫ��ʱ����
                if (first == null)
                    available.await();
                else {
                    //��������ִ��ʱ�䣬���delay�ǵ�ǰʱ���ȥ���񴥷�ʱ��
                    long delay = first.getDelay(NANOSECONDS);
                    //������˴���ʱ�䣬��ִ�г��Ӳ���
                    if (delay <= 0)
                        return finishPoll(first);
                    first = null;
                    //�����ʾ�������Ѿ�������������̣߳���ǰ�̵߳ȴ����ѾͿ���
                    if (leader != null)
                        available.await();
                    else {
                        //����Ѹ�����������ǰ�߳�
                        Thread thisThread = Thread.currentThread();
                        leader = thisThread;
                        try {
                            //��ǰ�̵߳ȴ�����ʣ���ӳ�ʱ��
                            available.awaitNanos(delay);
                        } finally {
                            //�����߳������Ժ�ʲôʱ��leader�ᷢ���仯�أ�
                            //�����������������ʱ��
                            if (leader == thisThread)
                                leader = null;
                        }
                    }
                }
            }
        } finally {
            //������в�Ϊ�գ���������woker�߳�
            if (leader == null && queue[0] != null)
                available.signal();
            lock.unlock();
        }
    }
     */

     /*
    public ScheduledFuture<?> schedule(Runnable command,
                                       long delay,
                                       TimeUnit unit) {
        if (command == null || unit == null)
            throw new NullPointerException();
        RunnableScheduledFuture<?> t = decorateTask(command,
            new ScheduledFutureTask<Void>(command, null,
                                          triggerTime(delay, unit)));
        delayedExecute(t);
        return t;
    }

     public <V> ScheduledFuture<V> schedule(Callable<V> callable,
                                            long delay,
                                            TimeUnit unit) {
         if (callable == null || unit == null)
             throw new NullPointerException();
         RunnableScheduledFuture<V> t = decorateTask(callable,
                 new java.util.concurrent.ScheduledThreadPoolExecutor.ScheduledFutureTask<V>(callable,
                         triggerTime(delay, unit)));
         delayedExecute(t);
         return t;
     }
    */

    /*
    public ScheduledFuture<?> scheduleAtFixedRate(Runnable command,
                                                  long initialDelay,
                                                  long period,
                                                  TimeUnit unit) {
        if (command == null || unit == null)
            throw new NullPointerException();
        if (period <= 0)
            throw new IllegalArgumentException();
        java.util.concurrent.ScheduledThreadPoolExecutor.ScheduledFutureTask<Void> sft =
                new java.util.concurrent.ScheduledThreadPoolExecutor.ScheduledFutureTask<Void>(command,
                        null,
                        triggerTime(initialDelay, unit),
                        unit.toNanos(period));
        RunnableScheduledFuture<Void> t = decorateTask(command, sft);
        sft.outerTask = t;
        delayedExecute(t);
        return t;
    }


    public ScheduledFuture<?> scheduleWithFixedDelay(Runnable command,
                                                     long initialDelay,
                                                     long delay,
                                                     TimeUnit unit) {
        if (command == null || unit == null)
            throw new NullPointerException();
        if (delay <= 0)
            throw new IllegalArgumentException();
        java.util.concurrent.ScheduledThreadPoolExecutor.ScheduledFutureTask<Void> sft =
                new java.util.concurrent.ScheduledThreadPoolExecutor.ScheduledFutureTask<Void>(command,
                        null,
                        triggerTime(initialDelay, unit),
                        unit.toNanos(-delay));
        RunnableScheduledFuture<Void> t = decorateTask(command, sft);
        sft.outerTask = t;
        delayedExecute(t);
        return t;
    }
      */
}
