package chap6.BinarySearchTree.example7.NonRecursionPreorderTraverseInBST;

/**
 * 6-9 二分搜索树前序遍历的"非递归"实现
 *   ● 二分搜索树遍历的非递归实现，比递归实现复杂很多
 *   ● 中序遍历和后序遍历的非递归实现更复杂
 *   ● 中序遍历和后序遍历的非递归实现，实际应用不广
 */
public class Main {

    public static void main(String[] args) {

        BST<Integer> bst = new BST<>();
        int[] nums = {5, 3, 6, 8, 4, 2};
        for(int num: nums)
            bst.add(num);

        /////////////////
        //      5      //
        //    /   \    //
        //   3    6    //
        //  / \    \   //
        // 2  4     8  //
        /////////////////
        bst.preOrder();
        System.out.println();

        bst.preOrderNR();
        System.out.println();
    }
}
/* Output:
5
3
2
4
6
8

5
3
2
4
6
8
*///~