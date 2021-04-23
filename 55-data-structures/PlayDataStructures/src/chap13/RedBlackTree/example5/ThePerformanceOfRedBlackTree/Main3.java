package chap13.RedBlackTree.example5.ThePerformanceOfRedBlackTree;

import java.util.ArrayList;
import java.util.Random;

/**
 * 测试添加操作 （顺序添加）
 */
public class Main3 {

    public static void main(String[] args) {

        int n = 20_000_000;

        ArrayList<Integer> testData = new ArrayList<>(n);
        for(int i = 0 ; i < n ; i ++)
            testData.add(i); // 顺序添加

        // Test AVL
        long startTime = System.nanoTime();

        AVLTree<Integer, Integer> avl = new AVLTree<>();
        for (Integer x: testData)
            avl.add(x, null);

        long endTime = System.nanoTime();

        double time = (endTime - startTime) / 1000000000.0;
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
/* Output:
AVL: 8.163123 s
RBTree: 8.5441643 s
*///~