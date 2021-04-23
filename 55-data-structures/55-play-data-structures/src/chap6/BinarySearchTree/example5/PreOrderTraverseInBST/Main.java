package chap6.BinarySearchTree.example5.PreOrderTraverseInBST;

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
        // 前序遍历
        bst.preOrder();
        System.out.println();

        System.out.println(bst);
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
--3
----2
------null
------null
----4
------null
------null
--6
----null
----8
------null
------null
*///~