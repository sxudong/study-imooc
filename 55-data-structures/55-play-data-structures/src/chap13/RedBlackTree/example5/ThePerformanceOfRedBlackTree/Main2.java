package chap13.RedBlackTree.example5.ThePerformanceOfRedBlackTree;

import java.util.ArrayList;
import java.util.Random;

//创建一个新的测试用例 Main2，在 Main2 中只看添加操作，相对于AVL是不是有一定的优势？
public class Main2 {
    /**
     * AVL树还要慢一点，原因也很好理解，因为完全随机的数据，其实对于我们的BST二分搜索树来说并不会完全退化成链表，它还是能基本保持平衡的，
     * 这是因为我们的数据整体是平均的。与此同时它也不要像AVL树那样做很多的旋转操作来维持树的平衡，所以反而会快一些。
     * 不过这里值得注意的是红黑树它也有维持平衡的过程，在这次测试过程中红黑树其实是最快的，对于红黑树来说添加操作相比于AVL树来说是有优势的。
     */
    public static void main(String[] args) {

        // int n = 20000000;
        int n = 20_000_000; // 2000W

        Random random = new Random(n); // 随机
        ArrayList<Integer> testData = new ArrayList<>(n);
        for(int i = 0 ; i < n ; i ++)
            testData.add(random.nextInt(Integer.MAX_VALUE)); // 添加操作

        // Test BST
        long startTime = System.nanoTime();

        BST<Integer, Integer> bst = new BST<>();
        for (Integer x: testData)
            bst.add(x, null);

        long endTime = System.nanoTime();

        double time = (endTime - startTime) / 1000000000.0;
        System.out.println("BST: " + time + " s");


        // Test AVL
        startTime = System.nanoTime();

        AVLTree<Integer, Integer> avl = new AVLTree<>();
        for (Integer x: testData)
            avl.add(x, null);

        endTime = System.nanoTime();

        time = (endTime - startTime) / 1000000000.0;
        System.out.println("AVL: " + time + " s");


        // Test RBTree
        startTime = System.nanoTime();

        RBTree<Integer, Integer> rbt = new RBTree<>();
        for (Integer x: testData)
            rbt.add(x, null);

        endTime = System.nanoTime();

        time = (endTime - startTime) / 1000000000.0;
        System.out.println("RBTree: " + time + " s");
    }
}
/* Output: 我的电脑上AVL是最快的
BST: 46.4936416 s
AVL: 44.6188082 s
RBTree: 45.2978882 s
*///~
