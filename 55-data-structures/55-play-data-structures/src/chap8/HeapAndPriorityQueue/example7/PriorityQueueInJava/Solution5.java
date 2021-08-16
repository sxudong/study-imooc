package chap8.HeapAndPriorityQueue.example7.PriorityQueueInJava;
/// 347. Top K Frequent Elements
/// https://leetcode.com/problems/top-k-frequent-elements/description/

import java.util.*;

/**
 * 8-8 Java中的 PriorityQueue
 * 使用 Java 自自已的 PriorityQueue 实现 347. 前 K 个高频元素
 *
 * 链接：https://leetcode-cn.com/problems/top-k-frequent-elements
 */
public class Solution5 {

    public List<Integer> topKFrequent(int[] nums, int k) {

        TreeMap<Integer, Integer> map = new TreeMap<>();
        for(int num: nums){
            if(map.containsKey(num))
                map.put(num, map.get(num) + 1);
            else
                map.put(num, 1);
        }

        PriorityQueue<Integer> pq = new PriorityQueue<>(
                (a, b) -> map.get(a) - map.get(b) //这种表达式使用不好，引用了外部数据
            );
        for(int key: map.keySet()){
            if(pq.size() < k)
                pq.add(key);
            else if(map.get(key) > map.get(pq.peek())){
                pq.remove();
                pq.add(key);
            }
        }

        LinkedList<Integer> res = new LinkedList<>();
        while(!pq.isEmpty())
            res.add(pq.remove());
        return res;
    }

    private static void printList(List<Integer> nums){
        for(Integer num: nums)
            System.out.print(num + " ");
        System.out.println();
    }

    public static void main(String[] args) {
        int[] nums = {1, 1, 1, 2, 2, 3};
        int k = 2;
        printList((new Solution5()).topKFrequent(nums, k));
    }
}
/* Output:
2 1
*///~