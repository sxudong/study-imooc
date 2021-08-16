package chap9.SegmentTree.example4.SegmentTreeProblemsInLeetcode;

/// Leetcode 307. Range Sum Query - Mutable
/// https://leetcode.com/problems/range-sum-query-mutable/description/
///
/// 使用sum数组的思路：TLE

/**
 * 9-5 Leetcode上线段树相关的问题
 *
 * 307. 区域和检索 - 数组可修改
 * 给定一个整数数组  nums，求出数组从索引 i 到 j  (i ≤ j) 范围内元素的总和，包含 i,  j 两点。
 *
 * update(i, val) 函数可以通过将下标为 i 的数值更新为 val，从而对数列进行修改。
 *
 * 示例:
 *
 * Given nums = [1, 3, 5]
 *
 * sumRange(0, 2) -> 9
 * update(1, 2)
 * sumRange(0, 2) -> 8
 *
 * 说明:
 * 数组仅可以在 update 函数下进行修改。
 * 你可以假设 update 函数与 sumRange 函数的调用次数是均匀分布的。
 */
class NumArray3 {

    private int[] data;
    private int[] sum;
    public NumArray3(int[] nums) {

        data = new int[nums.length];
        for(int i = 0 ; i < nums.length ; i ++)
            data[i] = nums[i];

        sum = new int[nums.length + 1];
        sum[0] = 0;
        for(int i = 1 ; i <= nums.length ; i ++)
            sum[i] = sum[i - 1] + nums[i - 1];
    }

    public int sumRange(int i, int j) {
        return sum[j + 1] - sum[i];
    }

    // 针对第index个索引元素修改成value
    public void update(int index, int val) {
        data[index] = val;
        for(int i = index + 1 ; i < sum.length ; i ++)
            sum[i] = sum[i - 1] + data[i - 1];
    }
}
