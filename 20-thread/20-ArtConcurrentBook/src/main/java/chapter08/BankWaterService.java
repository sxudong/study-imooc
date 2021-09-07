package chapter08;

import java.util.Map;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 8.2.2 CyclicBarrier的应用场景 代码清单8-5
 *
 * 用一个Excel保存了用户所有银行流水，每个 Sheet 保存一个账户近一年的每笔银行流水，现在需
 * 要统计用户的日均银行流水，先用多线程处理每个 sheet 里的银行流水，都执行完之后，得到每个
 * sheet 的日均银行流水，最后，再用barrierAction用这些线程的计算结果，计算出整个 Excel
 * 的日均银行流水，如下代码所示：
 */
public class BankWaterService implements Runnable {
    /**
     * 创建 4 个屏障，处理完之后执行当前类的 run 方法
     *
     * CyclicBarrier 提供一个更高级的构造函数 CyclicBarrier（int parties，Runnable barrierAction），
     * 用于在线程到达屏障时，优先执行 barrierAction，方便处理更复杂的业务场景
     */
    private CyclicBarrier c = new CyclicBarrier(4, this);
    /**
     * 假设只有 4 个sheet，所以只启动 4 个线程
     */
    private ExecutorService executor = Executors.newFixedThreadPool(4);
    /**
     * 保存每个 sheet 计算出的银流结果
     */
    private ConcurrentHashMap<String, Integer> sheetBankWaterCount = new ConcurrentHashMap<>();

    //private AtomicInteger atomic = new AtomicInteger(1);

    private void count() {
        for (int i = 0; i < 4; i++) {
            executor.execute(new Runnable() {
                @Override
                public void run() {
                    // 计算当前sheet的银流数据，计算代码省略
                    sheetBankWaterCount.put(Thread.currentThread().getName(), 1);
                    // 银流计算完成，插入一个屏障
                    try {
                        c.await(); //在4个线程都这里挂起后，CyclicBarrier c = new CyclicBarrier(4, this); this.run先运行计算。
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (BrokenBarrierException e) {
                        e.printStackTrace();
                    }
                    //System.out.println(atomic.getAndIncrement());
                }
            });
        }
        executor.shutdown();
    }

    @Override
    public void run() {
        int result = 0;
        // 汇总每个sheet计算出的结果
        for (Map.Entry<String, Integer> sheet : sheetBankWaterCount.entrySet()) {
            result += sheet.getValue();
        }
        // 将结果输出
        sheetBankWaterCount.put("result", result);
        System.out.println(result);
    }

    public static void main(String[] args) {
        BankWaterService bankWaterCount = new BankWaterService();
        bankWaterCount.count();
    }
}
// 使用线程池创建4个线程，分别计算每个sheet里的数据，每个sheet计算结果是1，再由
// BankWaterService线程汇总4个sheet计算出的结果，输出结果如下:
/*
4
*/