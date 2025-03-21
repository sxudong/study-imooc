package chap3.StacksAndQueues.example7.QueuesComparison;

import java.util.Random;

/**
 * 数组队列 和 循环队列 的比较
 */
public class Main {

    // 测试使用 q 运行 opCount 个 enqueue 和 dequeue 操作所需要的时间，单位：秒
    private static double testQueue(Queue<Integer> q, int opCount){

        long startTime = System.nanoTime();

        Random random = new Random();
        for(int i = 0 ; i < opCount ; i ++)
            q.enqueue(random.nextInt(Integer.MAX_VALUE));
        for(int i = 0 ; i < opCount ; i ++)
            q.dequeue(); //差异主要是在出队的操作上

        long endTime = System.nanoTime();

        return (endTime - startTime) / 1_000_000_000.0; //纳秒=>秒，10^9
    }

    public static void main(String[] args) {

        int opCount = 100_000;

        ArrayQueue<Integer> arrayQueue = new ArrayQueue<>();
        double time1 = testQueue(arrayQueue, opCount);
        System.out.println("ArrayQueue, time: " + time1 + " s");

        LoopQueue<Integer> loopQueue = new LoopQueue<>();
        double time2 = testQueue(loopQueue, opCount);
        System.out.println("LoopQueue, time: " + time2 + " s");
    }
}
/* Output:
ArrayQueue, time: 4.1001366 s
LoopQueue, time: 0.0123516 s
*///~