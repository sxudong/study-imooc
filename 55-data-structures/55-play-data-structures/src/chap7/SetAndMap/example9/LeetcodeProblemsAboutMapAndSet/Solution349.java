package chap7.SetAndMap.example9.LeetcodeProblemsAboutMapAndSet;
/// Leetcode 349. Intersection of Two Arrays 两个数组的交集
/// https://leetcode.com/problems/intersection-of-two-arrays/description/

import java.util.ArrayList;
import java.util.TreeSet;

/**
 * Leetcode 349. 两个数组的交集  -- 解决方案：借助Set集合去重，或是使用Map映射
 *   给定两个数组，编写一个函数来计算它们的交集。
 *   示例 1：
 *     输入：nums1 = [1,2,2,1], nums2 = [2,2]
 *     输出：[2]
 *
 *   示例 2：
 *     输入：nums1 = [4,9,5], nums2 = [9,4,9,8,4]
 *     输出：[9,4]

 *   说明：
 *     输出结果中的每个元素一定是唯一的。
 *     我们可以不考虑输出结果的顺序。
 * https://leetcode-cn.com/problems/intersection-of-two-arrays/
 */
class Solution349 {
    public int[] intersection(int[] nums1, int[] nums2) {

        TreeSet<Integer> set = new TreeSet<>();
        for(int num: nums1) //遍历数组nums1，元素放入到set集合中去重
            set.add(num);

        ArrayList<Integer> list = new ArrayList<>();
        //遍历nums2，set集合中包含的元素放入到list中
        for(int num: nums2){
            if(set.contains(num)){
                list.add(num);
                set.remove(num); // 删除已经添加到list中的元素，nums2中重复的元素就不再包含
            }
        }

        int[] res = new int[list.size()];
        for(int i = 0 ; i < list.size() ; i ++)
            res[i] = list.get(i);
        return res;
    }

    public static void main(String[] args) {
        int[] nums1 = {1,2,2,1};
        int[] nums2 = {2,2};
        Solution349 solution349 = new Solution349();
        int[] nums3 = solution349.intersection(nums1, nums2);
        for (int i : nums3) {
            System.out.println(i); //2
        }
    }
}
