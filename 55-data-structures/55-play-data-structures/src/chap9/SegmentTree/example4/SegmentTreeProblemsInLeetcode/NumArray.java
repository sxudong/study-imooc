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
class NumArray {
    private SegmentTree<Integer> segmentTree;

    public NumArray(int[] nums) {
        if(nums.length > 0){
            Integer[] data = new Integer[nums.length];
            for (int i = 0; i < nums.length; i++)
                data[i] = nums[i];
            // 创建线段树
            segmentTree = new SegmentTree<>(data, (a, b) -> a + b);
        }
    }

    public int sumRange(int i, int j) {
        if(segmentTree == null)
            throw new IllegalArgumentException("Segment Tree is null");
        return segmentTree.query(i, j);
    }
}
