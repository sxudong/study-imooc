package chap9.SegmentTree.example4.SegmentTreeProblemsInLeetcode;
/// 303. Range Sum Query - Immutable
/// https://leetcode.com/problems/range-sum-query-immutable/description/

/**
 * 9-5 Leetcode上线段树相关的问题
 *
 * 303. 区域和检索 - 数组不可变
 * 给定一个整数数组  nums，求出数组从索引 i 到 j  (i ≤ j) 范围内元素的总和，包含 i,  j 两点。
 *
 * 示例：
 * 给定 nums = [-2, 0, 3, -5, 2, -1]，求和函数为 sumRange()
 *
 * sumRange(0, 2) -> 1
 * sumRange(2, 5) -> -1
 * sumRange(0, 5) -> -3
 *
 * 说明:
 * 你可以假设数组不可变。
 * 会多次调用 sumRange 方法。
 *
 * 来源：力扣（LeetCode）
 * 链接：https://leetcode-cn.com/problems/range-sum-query-immutable
 */
public class NumArray2 {

    private int[] sum; // sum[i]存储前i个元素和, sum[0] = 0
                       // 即sum[i]存储nums[0...i-1]的和
                       // sumRange(i, j) = sum[j + 1] - sum[i]

    public NumArray2(int[] nums) {
        sum = new int[nums.length + 1];
        sum[0] = 0;
        // 初始化sum值
        for(int i = 1 ; i < sum.length ; i ++)
            // 从nums[0]开始前后两个数值累加，保存到sum中
            sum[i] = sum[i - 1] + nums[i - 1];
    }

    public int sumRange(int i, int j) {
        // sum[j + 1] 中存储的是 nums[0]到 j 这些元素的和
        // sum[i] 中存储的是  nums[0]到 i 的值
        return sum[j + 1] - sum[i];
    }
}
