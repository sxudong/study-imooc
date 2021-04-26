package chap7.SetAndMap.example9.LeetcodeProblemsAboutMapAndSet;
/// Leetcode 350. Intersection of Two Arrays II
/// https://leetcode.com/problems/intersection-of-two-arrays-ii/description/

import java.util.ArrayList;
import java.util.TreeMap;

/**
 * 350. 两个数组的交集 II
 *   给定两个数组，编写一个函数来计算它们的交集。
 *
 *   示例 1：
 *      输入：nums1 = [1,2,2,1], nums2 = [2,2]
 *      输出：[2,2]
 *   示例 2：
 *     输入：nums1 = [4,9,5], nums2 = [9,4,9,8,4]
 *     输出：[4,9]
 *
 *   说明：
 *     输出结果中每个元素出现的次数，应与元素在两个数组中出现次数的最小值一致。
 *     我们可以不考虑输出结果的顺序。
 * https://leetcode-cn.com/problems/intersection-of-two-arrays-ii/
 */
public class Solution350 {

    public int[] intersect(int[] nums1, int[] nums2) {

        TreeMap<Integer, Integer> map = new TreeMap<>();
        for(int num: nums1){
            if(!map.containsKey(num))
                map.put(num, 1);
            else
                map.put(num, map.get(num) + 1); // 通过Map映射记录 频次 +1
        }

        ArrayList<Integer> res = new ArrayList<>();
        for(int num: nums2){
            if(map.containsKey(num)){
                res.add(num);
                map.put(num, map.get(num) - 1); // 词频 -1 只要map值不等于0，遇到重复的值就可以往里面再次添加
                if(map.get(num) == 0)           // 词频 =0 从map中移除
                    map.remove(num);
            }
        }

        int[] ret = new int[res.size()];
        for(int i = 0 ; i < res.size() ; i ++)
            ret[i] = res.get(i);

        return ret;
    }

    public static void main(String[] args) {
        int[] nums1 = {4,9,5,4};
        int[] nums2 = {9,4,8,4};
        Solution350 solution3solution350 = new Solution350();
        int[] nums3 = solution3solution350.intersect(nums1, nums2);
        for (int i : nums3) {
            System.out.println(i); //9,4,4
        }
    }
}
/* 使用349集合方法实现，少一步从set集合中删除重复元素就可以了
        TreeSet<Integer> set = new TreeSet<>();
        for(int num: nums1)
            set.add(num);

        ArrayList<Integer> list = new ArrayList<>();
        for(int num: nums2){
            if(set.contains(num)){
                list.add(num);
            }
        }

        int[] res = new int[list.size()];
        for(int i = 0 ; i < list.size() ; i ++)
            res[i] = list.get(i);
        return res;
 */