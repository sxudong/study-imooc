package chap9.SegmentTree.example3.QueryInSegmentTree;

/// 该测试用例来源：Leetcode 303. Range Sum Query - Immutable
/// https://leetcode.com/problems/range-sum-query-immutable/description/

public class Main {

    public static void main(String[] args) {

        Integer[] nums = {-2, 0, 3, -5, 2, -1};

        SegmentTree<Integer> segTree = new SegmentTree<>(nums,  (a, b) -> a + b);
        System.out.println(segTree);

        System.out.println(segTree.query(0, 2)); // -2 + 0 + 3 = 1
        System.out.println(segTree.query(2, 5)); // 3 + -5 + 2 + -1 = -1
        System.out.println(segTree.query(0, 5)); // -2 + 0 + 3 + -5 + 2 + -1 = -3
    }
}
/* Output:
[-3, 1, -4, -2, 3, -3, -1, -2, 0, null, null, -5, 2, null, null, null, null, null, null, null, null, null, null, null]
1
-1
-3
*///~