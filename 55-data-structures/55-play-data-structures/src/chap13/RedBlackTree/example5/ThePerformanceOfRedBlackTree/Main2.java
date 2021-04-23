package chap13.RedBlackTree.example5.ThePerformanceOfRedBlackTree;

import java.util.ArrayList;
import java.util.Random;

public class Main2 {

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
/* Output: 红黑树是最快的
BST: 46.4936416 s
AVL: 44.6188082 s
RBTree: 45.2978882 s
*///~