package chapter10.source;

import java.util.concurrent.*;

public class ScheduledThreadPoolExecutor {

    // 首先是schedule方法，该方法是指任务在指定延迟时间到达后触发，只会执行一次。
    /*
    public ScheduledFuture<?> schedule(Runnable command,
                                       long delay,
                                       TimeUnit unit) {
        //参数校验
        if (command == null || unit == null)
            throw new NullPointerException();
        //这里是一个嵌套结构，首先把用户提交的任务包装成ScheduledFutureTask
        //然后在调用decorateTask进行包装，该方法是留给用户去扩展的，默认是个空方法
        RunnableScheduledFuture<?> t = decorateTask(command,
                new ScheduledFutureTask<Void>(command, null,
                        triggerTime(delay, unit)));
        //包装好任务以后，就进行提交了
        delayedExecute(t);
        return t;
    }
   */

    /*
        private void delayedExecute(RunnableScheduledFuture<?> task) {
        //如果线程池已经关闭，则使用拒绝策略把提交任务拒绝掉
        if (isShutdown())
            reject(task);
        else {
            //与ThreadPoolExecutor不同，这里直接把任务加入延迟队列
            super.getQueue().add(task);
            //如果当前状态无法执行任务，则取消
            if (isShutdown() &&
                !canRunInCurrentRunState(task.isPeriodic()) &&
                remove(task))
                task.cancel(false);
            else
                //这里是增加一个worker线程，避免提交的任务没有worker去执行
                //原因就是该类没有像ThreadPoolExecutor一样，woker满了才放入队列
                ensurePrestart();
        }
    }
     */

    // 将指定的元素插入到队列中
    /*
            public boolean offer(Runnable x) {
            //参数校验
            if (x == null)
                throw new NullPointerException();
            RunnableScheduledFuture<?> e = (RunnableScheduledFuture<?>)x;
            final ReentrantLock lock = this.lock;
            lock.lock();
            try {
                //查看当前元素数量，如果大于队列长度则进行扩容
                int i = size;
                if (i >= queue.length)
                    grow();
                //元素数量加1
                size = i + 1;
                //如果当前队列还没有元素，则直接加入头部
                if (i == 0) {
                    queue[0] = e;
                    //记录索引
                    setIndex(e, 0);
                } else {
                    //把任务加入堆中，并调整堆结构，这里就会根据任务的触发时间排列
                    //把需要最早执行的任务放在前面
                    siftUp(i, e);
                }
                //如果新加入的元素就是队列头，这里有两种情况
                //1.这是用户提交的第一个任务
                //2.新任务进行堆调整以后，排在队列头
                if (queue[0] == e) {
                    //这个变量起优化作用，后面说
                    leader = null;
                    //加入元素以后，唤醒worker线程
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
                //取出队列中第一个元素，即最早需要执行的任务
                RunnableScheduledFuture<?> first = queue[0];
                //如果队列为空，则阻塞等待加入元素时唤醒
                if (first == null)
                    available.await();
                else {
                    //计算任务执行时间，这个delay是当前时间减去任务触发时间
                    long delay = first.getDelay(NANOSECONDS);
                    //如果到了触发时间，则执行出队操作
                    if (delay <= 0)
                        return finishPoll(first);
                    first = null;
                    //这里表示该任务已经分配给了其他线程，当前线程等待唤醒就可以
                    if (leader != null)
                        available.await();
                    else {
                        //否则把给任务分配给当前线程
                        Thread thisThread = Thread.currentThread();
                        leader = thisThread;
                        try {
                            //当前线程等待任务剩余延迟时间
                            available.awaitNanos(delay);
                        } finally {
                            //这里线程醒来以后，什么时候leader会发生变化呢？
                            //就是上面的添加任务的时候
                            if (leader == thisThread)
                                leader = null;
                        }
                    }
                }
            }
        } finally {
            //如果队列不为空，则唤醒其他woker线程
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