package chap6.BinarySearchTree.example2.AddElementsInBST;

/**
 * 6-3 向二分搜过树中添加元素
 *
 * 我们的二分搜索树不包含重复元素
 * 如果想包含重复元素的话，只需要定义: 左子树小于等于节点; 或者右子树大于等于节点。
 *
 * 注意: 我们之前讲的数组和链表，可以有重复元素
 *
 * ● 二分搜索树添加元素的非递归写法，和链表很像
 * ● 这个课程在二分搜索树方面的实现，关注递归实现
 * ● 二分搜索树一些方法的非递归实现，留做练习
 * ● 在二分搜索树方面，递归比非递归实现简单: )
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

        if(root == null){
            root = new Node(e);
            size ++;
        }
        else { // 如果不为空从根节点插入元素
            add(root, e);
        }
    }

    // 向以node为根的二分搜索树中插入元素e，递归算法
    private void add(Node node, E e){
        // 1、递归终止的条件
        // 要插入的这个e是不是等于node.e, 说明要插入的这个元素在这个二叉树中已经有了
        if(e.equals(node.e))
            return;
        // 如果是小于这个 e 的，那么要把这个 e 插入到 node 的左子树
        // BigInteger.compareTo(val) signum > val.signum ? 1 : -1;
        else if(e.compareTo(node.e) < 0 && node.left == null){
            // 放在左孩子
            node.left = new Node(e);
            size ++;
            return;
        }
        else if(e.compareTo(node.e) > 0 && node.right == null){
            // 放在右孩子
            node.right = new Node(e);
            size ++;
            return;
        }

        // 2、转换成更小的问题
        if(e.compareTo(node.e) < 0)
            add(node.left, e); // 递归调用
        else //e.compareTo(node.e) > 0
            add(node.right, e);
    }
}
