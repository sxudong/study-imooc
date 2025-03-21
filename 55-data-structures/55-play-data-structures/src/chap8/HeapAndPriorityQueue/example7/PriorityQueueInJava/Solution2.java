package chap8.HeapAndPriorityQueue.example7.PriorityQueueInJava;
/// 347. Top K Frequent Elements
/// https://leetcode.com/problems/top-k-frequent-elements/description/

import java.util.*;

public class Solution2 {

    private class Freq{
        //e是元素，freq是频次
        public int e, freq;

        public Freq(int e, int freq){
            this.e = e;
            this.freq = freq;
        }
    }

    /**
     * 实现 Java 的 Comparator 比较接口
     */
    private class FreqComparator implements Comparator<Freq>{

        @Override
        public int compare(Freq a, Freq b){
            return a.freq - b.freq;
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

        // 构造一个比较器传进去
        //PriorityQueue<Freq> pq = new PriorityQueue<>(new FreqComparator());
        //传一个lamdba表达式的比较器
        PriorityQueue<Freq> pq = new PriorityQueue<>((a,b) -> a.freq - b.freq);
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
        printList((new Solution2()).topKFrequent(nums, k));
    }
}
/* Output:
2 1
*///~