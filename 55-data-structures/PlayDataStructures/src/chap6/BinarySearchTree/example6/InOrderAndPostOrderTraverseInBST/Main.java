package chap6.BinarySearchTree.example6.InOrderAndPostOrderTraverseInBST;

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

        bst.inOrder();
        System.out.println(); // 结果是顺序的

        bst.postOrder();
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
*///~