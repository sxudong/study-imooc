package chap15.BTree;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

// 理解 B+树 的原理对学习 MySQL 有至关重要的作用。
// https://www.cnblogs.com/jssj/p/12897709.html
public class BPlusTreeTest {
    // 测试
    public static void main(String[] args) {
        int size = 10;
        int order = 3; // 每个空间最多可以存多少数据

        testRandomInsert(size, order); // 插入10个随机数

        testOrderInsert(size, order);

        testRandomSearch(size, order);

        testOrderSearch(size, order);

        testRandomRemove(size, order);

        testOrderRemove(size, order);
    }

    private static void testRandomRemove(int size, int order) {
        BPlusTree<Integer, Integer> tree = new BPlusTree<Integer, Integer>(order);
        // System.out.println("\nTest random remove " + size + " datas, of order:" + order);
        System.out.println("\n测试随机删除 " + size + " datas, of order:" + order);
        Random random = new Random();
        boolean[] a = new boolean[size + 10];
        List<Integer> list = new ArrayList<Integer>();
        int randomNumber = 0;
        // System.out.println("Begin random insert...");
        System.out.println("开始随机插入...");
        for (int i = 0; i < size; i++) {
            randomNumber = random.nextInt(size);
            a[randomNumber] = true;
            list.add(randomNumber);
            tree.insertOrUpdate(randomNumber, randomNumber);
        }
        tree.printBPlusTree();
        // System.out.println("Begin random remove...");
        System.out.println("开始随机删除...");
        long current = System.currentTimeMillis();
        for (int j = 0; j < size; j++) {
            randomNumber = list.get(j);
            if (a[randomNumber]) {
                if (tree.remove(randomNumber) == null) {
                    System.err.println("得不到数据:" + randomNumber);
                    break;
                } else {
                    a[randomNumber] = false;
                }
            }
        }
        long duration = System.currentTimeMillis() - current;
        // System.out.println("time elpsed for duration: " + duration);
        System.out.println("持续时间: " + duration);
        tree.printBPlusTree();
        System.out.println("树高："+tree.getHeight());
    }

    private static void testOrderRemove(int size, int order) {
        BPlusTree<Integer, Integer> tree = new BPlusTree<Integer, Integer>(order);
        System.out.println("\nTest order remove " + size + " datas, of order:"
                + order);
        System.out.println("Begin order insert...");
        for (int i = 0; i < size; i++) {
            tree.insertOrUpdate(i, i);
        }
        tree.printBPlusTree();
        System.out.println("Begin order remove...");
        long current = System.currentTimeMillis();
        for (int j = 0; j < size; j++) {
            if (tree.remove(j) == null) {
                System.err.println("得不到数据:" + j);
                break;
            }
        }
        long duration = System.currentTimeMillis() - current;
        // System.out.println("time elpsed for duration: " + duration);
        System.out.println("持续时间: " + duration);
        tree.printBPlusTree();
        System.out.println("树高："+tree.getHeight());
    }


    private static void testRandomSearch(int size, int order) {
        BPlusTree<Integer, Integer> tree = new BPlusTree<Integer, Integer>(order);
        // System.out.println("\nTest random search " + size + " datas, of order:" + order);
        System.out.println("\n测试随机搜寻 " + size + " datas, of order:" + order);

        Random random = new Random();
        boolean[] a = new boolean[size + 10];
        int randomNumber = 0;
        // System.out.println("Begin random insert...");
        System.out.println("开始随机插入...");
        for (int i = 0; i < size; i++) {
            randomNumber = random.nextInt(size);
            a[randomNumber] = true;
            tree.insertOrUpdate(randomNumber, randomNumber);
        }
        tree.printBPlusTree();
        // System.out.println("Begin random search...");
        System.out.println("开始随机搜索...");
        long current = System.currentTimeMillis();
        for (int j = 0; j < size; j++) {
            randomNumber = random.nextInt(size);
            if (a[randomNumber]) {
                if (tree.get(randomNumber) == null) {
                    System.err.println("得不到数据:" + randomNumber);
                    break;
                }
            }
        }
        long duration = System.currentTimeMillis() - current;
        // System.out.println("time elpsed for duration: " + duration);
        System.out.println("持续时间: " + duration);
    }

    private static void testOrderSearch(int size, int order) {
        BPlusTree<Integer, Integer> tree = new BPlusTree<Integer, Integer>(order);
        System.out.println("\nTest order search " + size + " datas, of order:" + order);
        // System.out.println("Begin order insert...");
        System.out.println("开始 order 插入...");
        for (int i = 0; i < size; i++) {
            tree.insertOrUpdate(i, i);
        }
        tree.printBPlusTree();
        // System.out.println("Begin order search...");
        System.out.println("开始 order 搜索...");
        long current = System.currentTimeMillis();
        for (int j = 0; j < size; j++) {
            if (tree.get(j) == null) {
                System.err.println("得不到数据:" + j);
                break;
            }
        }
        long duration = System.currentTimeMillis() - current;
        // System.out.println("time elpsed for duration: " + duration);
        System.out.println("持续时间: " + duration);
    }


    private static void testRandomInsert(int size, int order) {
        BPlusTree<Integer, Integer> tree = new BPlusTree<Integer, Integer>(order);
        // System.out.println("\nTest random insert " + size + " datas, of order:" + order);
        System.out.println("\n测试随机插入 " + size + " datas, of order:" + order);

        Random random = new Random();
        int randomNumber = 0;
        long current = System.currentTimeMillis();
        // 插入10个随机数
        for (int i = 0; i < size; i++) {
            randomNumber = random.nextInt(size * 10);
            System.out.print(randomNumber + " ");
            tree.insertOrUpdate(randomNumber, randomNumber);
        }
        long duration = System.currentTimeMillis() - current;
        // System.out.println("time elpsed for duration: " + duration);
        System.out.println("持续时间: " + duration);
        tree.printBPlusTree();
        System.out.println("树高："+tree.getHeight());
    }

    private static void testOrderInsert(int size, int order) {
        BPlusTree<Integer, Integer> tree = new BPlusTree<Integer, Integer>(order);
        System.out.println("\nTest order insert " + size + " datas, of order:" + order);
        long current = System.currentTimeMillis();
        for (int i = 0; i < size; i++) {
            System.out.print(i + " ");
            tree.insertOrUpdate(i, i);
        }
        long duration = System.currentTimeMillis() - current;
        // System.out.println("time elpsed for duration: " + duration);
        System.out.println("持续时间: " + duration);
        tree.printBPlusTree();
        System.out.println("树高："+tree.getHeight());
    }
}
/* Output:
测试随机插入 10 datas, of order:3
38 53 90 32 99 73 55 44 46 98 持续时间: 0
层级：0,非叶子节点，keys为: 53=53
层级：1,非叶子节点，keys为: 44=44
层级：2,叶子节点，keys为: 32=32 38=38
层级：2,叶子节点，keys为: 44=44 46=46
层级：1,非叶子节点，keys为: 90=90
层级：2,叶子节点，keys为: 53=53 55=55 73=73
层级：2,叶子节点，keys为: 90=90 98=98 99=99
树高：2

测试随机搜寻 10 datas, of order:3
开始随机插入...
层级：0,非叶子节点，keys为: 2=2 6=6
层级：1,叶子节点，keys为: 0=0 1=1
层级：1,叶子节点，keys为: 2=2 4=4
层级：1,叶子节点，keys为: 6=6 8=8 9=9
开始随机搜索...
持续时间: 0

测试随机删除 10 datas, of order:3
开始随机插入...
层级：0,非叶子节点，keys为: 2=2 6=6
层级：1,叶子节点，keys为: 0=0 1=1
层级：1,叶子节点，keys为: 2=2 3=3
层级：1,叶子节点，keys为: 6=6 9=9
开始随机删除...
持续时间: 1
层级：0,叶子节点，keys为:
树高：0
 */