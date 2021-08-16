package chap6.BinarySearchTree.example4.SearchInBST;

/**
 * 二分搜索树的查询操作
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
        if(node == null){
            size ++;
            return new Node(e);
        }

        //判断插入是在左子树中，还是在右子树中
        if(e.compareTo(node.e) < 0)
            node.left = add(node.left, e);
        else if(e.compareTo(node.e) > 0)
            node.right = add(node.right, e);

        return node;
    }

    // 看二分搜索树中是否包含元素e
    public boolean contains(E e){
        return contains(root, e); // 从二分树的根开始
    }

    // 看以node为根的二分搜索树中是否包含元素e, 递归算法
    private boolean contains(Node node, E e){

        // 1、递归终止的条件
        if(node == null)
            return false;

        // 2、转换成更小的问题
        if(e.compareTo(node.e) == 0)
            return true;
        else if(e.compareTo(node.e) < 0)    // 左子树查询
            return contains(node.left, e);  // 递归
        else // e.compareTo(node.e) > 0     // 右子树查询
            return contains(node.right, e); // 递归
    }
}
