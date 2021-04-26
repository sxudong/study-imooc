package chap6.BinarySearchTree.example8.LevelTraverseInBST;

/**
 * 6-10 二分搜索树的"层序遍历"
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
        bst.preOrder(); //前序遍历
        System.out.println();

        bst.inOrder(); //中序遍历
        System.out.println();

        bst.postOrder(); //非递归 使用Stack实现的遍历
        System.out.println();

        bst.levelOrder(); //层序遍历 使用LinkList实现的遍历
        System.out.println();
    }
}
/*
5
3
2
4
6
8

2
3
4
5
6
8

2
4
3
8
6
5

5
3
6
2
4
8
*///~