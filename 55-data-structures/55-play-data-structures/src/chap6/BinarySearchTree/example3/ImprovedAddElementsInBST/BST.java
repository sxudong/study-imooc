package chap6.BinarySearchTree.example3.ImprovedAddElementsInBST;

/**
 * 改进添加操作
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

    private Node root;
    private int size;

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

    // 向二分搜索树中添加新的元素e
    public void add(E e){
        root = add(root, e);
    }

    // 向以node为根的二分搜索树中插入元素e，递归算法
    // 返回插入新节点后二分搜索树的根
    private Node add(Node node, E e){
        // 1、递归终止的条件
        if(node == null){
            size ++;
            return new Node(e); // 返回一个新的节点
        }

        // 2、转换成更小的问题
        // 判断插入是在左子树中，还是在右子树中
        if(e.compareTo(node.e) < 0)
            node.left = add(node.left, e); // 递归调用，新节点返回
        else if(e.compareTo(node.e) > 0)
            node.right = add(node.right, e);

        return node;
    }
}
