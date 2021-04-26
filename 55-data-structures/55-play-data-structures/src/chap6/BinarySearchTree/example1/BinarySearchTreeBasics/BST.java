package chap6.BinarySearchTree.example1.BinarySearchTreeBasics;

/**
 * 6-2 二分搜索树基础
 * @param <E>
 */
public class BST<E extends Comparable<E>> {

    private class Node {
        public E e;
        public Node left, right;

        public Node(E e) {
            this.e = e;
            left = null;
            right = null;
        }
    }

    private Node root; // 根节点
    private int size;  // 存储了多少个元素

    public BST(){
        root = null;
        size = 0;
    }

    public int size(){
        return size;
    }

    public boolean isEmpty(){
        return size == 0;
    }
    public static void test2(int n) {
        // O(n)
        // 1 + 3n
        for (int i = 0; i < n; i++) {
            System.out.println("test");
        }
    }

}
