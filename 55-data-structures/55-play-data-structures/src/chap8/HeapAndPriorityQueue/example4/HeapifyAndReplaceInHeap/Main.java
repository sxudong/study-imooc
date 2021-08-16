package chap8.HeapAndPriorityQueue.example4.HeapifyAndReplaceInHeap;

import java.util.Arrays;
import java.util.Random;

public class Main {

    private static double testHeap(Integer[] testData, boolean isHeapify){

        long startTime = System.nanoTime();

        MaxHeap<Integer> maxHeap;
        if(isHeapify)
            maxHeap = new MaxHeap<>(testData); // 根据传入的数组创建堆
        else{
            maxHeap = new MaxHeap<>(testData.length);
            for(int num: testData)
                maxHeap.add(num);
        }

        int[] arr = new int[testData.length];
        for(int i = 0 ; i < testData.length ; i ++)
            arr[i] = maxHeap.extractMax();

        // 验证两邻的两个数，如果前一个数比后一个数还要小，
        // 那么它就不是一个降序的序列，说明这个堆有问题
        for(int i = 1 ; i < testData.length ; i ++)
            if(arr[i-1] < arr[i])
                throw new IllegalArgumentException("Error");
        System.out.println("Test MaxHeap completed.");

        long endTime = System.nanoTime();

        return (endTime - startTime) / 1000000000.0;
    }

    public static void main(String[] args) {

        int n = 1000000;

        Random random = new Random();
        Integer[] testData1 = new Integer[n];
        for(int i = 0 ; i < n ; i ++)
            testData1[i] = random.nextInt(Integer.MAX_VALUE);

        Integer[] testData2 = Arrays.copyOf(testData1, n);

        // 从一个空堆中一个一个添加 testData1 中的元素
        double time1 = testHeap(testData1, false);
        System.out.println("Without heapify: " + time1 + " s");

        // 使用 Heapify
        double time2 = testHeap(testData2, true);
        System.out.println("With heapify: " + time2 + " s");
    }
}
/* 比起人空堆中一个一个添加元素，从复杂度来说是有一个质的飞跃的
Test MaxHeap completed.
Without heapify: 1.883074179 s
Test MaxHeap completed.
With heapify: 1.126421874 s
*///~