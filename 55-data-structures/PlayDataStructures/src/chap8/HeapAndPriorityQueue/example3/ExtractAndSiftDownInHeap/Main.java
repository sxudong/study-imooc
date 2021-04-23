package chap8.HeapAndPriorityQueue.example3.ExtractAndSiftDownInHeap;

import java.util.Random;

/**
 * 8-4 从堆中取出元素和 Sift Down
 */
public class Main {

    public static void main(String[] args) {

        int n = 1000000; // 100W

        MaxHeap<Integer> maxHeap = new MaxHeap<>();
        Random random = new Random();
        for(int i = 0 ; i < n ; i ++)
            maxHeap.add(random.nextInt(Integer.MAX_VALUE));

        int[] arr = new int[n];
        for(int i = 0 ; i < n ; i ++)
            arr[i] = maxHeap.extractMax();
            // 取出堆中最大元素，现在这个arr中的元素应该是从大到小排序的

        // 验证两邻的两个数，如果前一个数比后一个数还要小，
        // 那么它就不是一个降序的序列，说明这个堆有问题
        for(int i = 1 ; i < n ; i ++)
            if(arr[i-1] < arr[i])
                throw new IllegalArgumentException("Error");

        System.out.println("Test MaxHeap completed.");
    }
}
/* Output:
Test MaxHeap completed.
*///~