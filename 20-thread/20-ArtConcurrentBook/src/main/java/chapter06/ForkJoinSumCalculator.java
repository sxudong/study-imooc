package chapter06;

import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;
import java.util.concurrent.ForkJoinTask;
import java.util.function.Function;
import java.util.stream.LongStream;

/**
 * 《Java8 实战》7.2.1 使用 RecursiveTask
 *
 * 代码清单7-2 用 分支/合并 框架执行并行求和
 */
public class ForkJoinSumCalculator extends RecursiveTask<Long> {
    // 使用多个ForkJoinPool没有什么意义，实例保存在静态字段中，使之成为单例，方便在软件任何地方重用
    public static final ForkJoinPool FORK_JOIN_POOL = new ForkJoinPool();

    public static final long THRESHOLD = 10_000; // 不再将任务分解为子任务的数组大小

    private final long[] numbers; // 要求和的数组
    private final int start;      // 子任务处理的数组的起始位置
    private final int end;        // 子任务处理的数组的终止位置

    public ForkJoinSumCalculator(long[] numbers) { // 公共构造器函数
        this(numbers, 0, numbers.length); // 调用私有构造器函数
    }

    // 用于以递归方式为主任务 创建 子任务
    private ForkJoinSumCalculator(long[] numbers, int start, int end) { // 私有构造函数
        this.numbers = numbers;
        this.start = start;
        this.end = end;
    }

    /**
     * 定义任务拆分成子任务的逻辑，以及无法再拆分
     * 或不方便再拆分时，生成单个了任务结果的逻辑。
     */
    @Override
    protected Long compute() {
        int length = end - start; // 该任务负责求和的部分的大小

        //如果大小小于等于阀值,则顺序计算结果
        if (length <= THRESHOLD) {
            return computeSequentially();
        }

        //System.out.println(String.format("split %d~%d ==> %d~%d, %d~%d", start, end, start, start + length/2, start + length/2, end));

        // 如果大于 阈值，将任务分成两个了任务
        // 创建一个子任务来为数组的前一半求和
        ForkJoinSumCalculator leftTask = new ForkJoinSumCalculator(numbers, start, start + length/2);
        // 利用另一个 ForkJoinPool 线程"异步"执行新创建的子任务
        leftTask.fork();

        // 创建一个任务为数组的后一半求和
        ForkJoinSumCalculator rightTask = new ForkJoinSumCalculator(numbers, start + length/2, end);
        //**递归操作**     同步执行第二个子任务，有可能允许进一步递归划分
        Long rightResult = rightTask.compute();
        // 遇到递归终止条件,读取本次递归第一个子任务的结果,如果尚未完成就等待
        Long leftResult = leftTask.join();
        // 递归累加 该任务的结果是两个子任务结果的组合
        return leftResult + rightResult;
    }

    // 在子任务不再可分时计算结果的简单算法
    private long computeSequentially() {
        long sum = 0;
        for (int i = start; i < end; i++) {
            sum += numbers[i];
        }
        return sum;
    }

    // 现在编写一个方法来并行对前 n 个自然数求和就很简单了。
    // 你只需把想要的数字数组传给 ForkJoinSumCalculator 的构造函数
    public static long forkJoinSum(long n) {
        // 生成包含前n个自然数的数组
        long[] numbers = LongStream.rangeClosed(1, n).toArray();
        // 创建一个ForkJoinTask，把数组传递给ForkJoinSumCalculator公共构造函数
        ForkJoinTask<Long> task = new ForkJoinSumCalculator(numbers);
        // 创建一个新的ForkJoinPool,把任务传递给它的调用方法。
        return FORK_JOIN_POOL.invoke(task); // 在ForkJoinPool中执行时，最后一个方法返回的值就是ForkJoinSumCalculator类定义的任务结果。
    }

    public static void main(String[] args) {
        // 7.2.1 分支/合并框架 使用自定义的分支/合并 并行流
        System.out.println("ForkJoin sum done in: " +
                measurePerf(ForkJoinSumCalculator::forkJoinSum, 10_000_000L) + " msecs" ); // 59 msecs
    }

    public static <T, R> long measurePerf(Function<T, R> f, T input) {
        long fastest = Long.MAX_VALUE;
        for (int i = 0; i < 10; i++) {
            long start = System.nanoTime();
            R result = f.apply(input);
            long duration = (System.nanoTime() - start) / 1_000_000;
            System.out.println("Result: " + result);
            if (duration < fastest) fastest = duration;
        }
        return fastest;
    }
}/* Output:
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
Result: 50000005000000
ForkJoin sum done in: 59 msecs
*/

/**
 * java.util.concurrent.ForkJoinTask
 *
 * public final ForkJoinTask<V> fork() {
 *     //定义一个线程实例属性t
 *     Thread t;
 *     //取得当前线程实例赋值给t，然后判断该线程是否是ForkJoinWorkerThread类型
 *     if ((t = Thread.currentThread()) instanceof ForkJoinWorkerThread)
 *         //如果是，则把该任务加入到当前线程的工作队列中
 *         ((ForkJoinWorkerThread)t).workQueue.push(this);
 *     else
 *         //否则把该任务加入到默认 common 线程池中
 *         ForkJoinPool.common.externalPush(this);
 *     return this;
 * }
 *
 * 所以fork()方法的主要作用就是把任务加入到当前线程的工作队列中，同时只有显式的创建 ForkJoinPool 线程池，
 * 才能使用到默认的工厂类，才能创建出 ForkJoinWorkerThread 类型的线程，而像 Java8 的并行流，
 * 用的虽然也是 ForkJoinPool 线程池，但是默认使用的是 common 线程池。
 *
 * 因为 ForkJoinTask 一定会运行在一个 ForkJoinPool 中，如果没有显式地交它提交到ForkJoinPool，
 * 会使用一个 common池（全进程共享）来执行任务。
 */
