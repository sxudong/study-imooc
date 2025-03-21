package chap8.HeapAndPriorityQueue.example7.PriorityQueueInJava;
/// 347. Top K Frequent Elements
/// https://leetcode.com/problems/top-k-frequent-elements/description/

import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.TreeMap;

/**
 * 8-8 Java中的 PriorityQueue
 * 使用 Java 自自已的 PriorityQueue 实现 347. 前 K 个高频元素
 *
 * 链接：https://leetcode-cn.com/problems/top-k-frequent-elements
 */
public class Solution {

    private class Freq implements Comparable<Freq>{
        //e是元素，freq是频次
        public int e, freq;

        public Freq(int e, int freq){
            this.e = e;
            this.freq = freq;
        }

        public int compareTo(Freq another){
            if(this.freq < another.freq)
                //return 1;
                return -1; //使用Java的优先队列，这里需要做一个变更
            else if(this.freq > another.freq)
                //return -1;
                return 1;
            else
                return 0;
        }
    }

    public List<Integer> topKFrequent(int[] nums, int k) {

        TreeMap<Integer, Integer> map = new TreeMap<>();
        for(int num: nums){
            if(map.containsKey(num))
                map.put(num, map.get(num) + 1);
            else
                map.put(num, 1);
        }

        // Java 中的 PriorityQueue 是最小堆
        PriorityQueue<Freq> pq = new PriorityQueue<>();
        for(int key: map.keySet()){
            if(pq.size() < k)
                pq.add(new Freq(key, map.get(key)));
            else if(map.get(key) > pq.peek().freq){
                pq.remove();
                pq.add(new Freq(key, map.get(key)));
            }
        }

        LinkedList<Integer> res = new LinkedList<>();
        while(!pq.isEmpty())
            res.add(pq.remove().e);
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
        printList((new Solution()).topKFrequent(nums, k));
    }
}
/* Output:
2 1
*///~