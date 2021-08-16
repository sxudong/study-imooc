package chap6.BinarySearchTree.example5.PreOrderTraverseInBST;

/**
 * 6-6 二分搜索书的前序遍历
 *
 * ● 遍历操作就是把所有节点都访问一遍
 * ● 访问的原因和业务相关
 * ● 在线性结构下，遍历是极其容易的
 * ● 在树结构下，也没那么难: )
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

    // 向以 node 为根的二分搜索树中插入元素e，递归算法
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
        return contains(root, e);
    }

    // 看以node为根的二分搜索树中是否包含元素e, 递归算法
    private boolean contains(Node node, E e){

        if(node == null)
            return false;

        if(e.compareTo(node.e) == 0)
            return true;
        else if(e.compareTo(node.e) < 0)
            return contains(node.left, e);
        else // e.compareTo(node.e) > 0
            return contains(node.right, e);
    }

    // 二分搜索树的前序遍历
    public void preOrder(){
        preOrder(root);
    }

    /**
     * 前序遍历以 node 为根的二分搜索树, 递归算法
     *
     * 为什么叫前序遍历？
     * 访问节点在左右节点前面，所以叫前序遍历。
     */
    private void preOrder(Node node){
        // 1、递归终止的条件
        if(node == null)
            return;

        System.out.println(node.e);
        // 2、转换成更小的问题，如果没有终止
        preOrder(node.left);  // 递归遍历左边
        preOrder(node.right); // 递归遍历右边
    }

    @Override
    public String toString(){
        StringBuilder res = new StringBuilder();
        generateBSTString(root, 0, res);
        return res.toString();
    }


    /**
     * 生成以 node 为根节点，深度为 depth 的描述二叉树的字符串
     * @param node  根节点
     * @param depth 深度
     * @param res   描述二叉树的字符串
     */
    private void generateBSTString(Node node, int depth, StringBuilder res){

        // 1、递归终止的条件
        if(node == null){
            res.append(generateDepthString(depth) + "null\n");
            return;
        }

        // 2、转换成更小的问题，如果不为空
        res.append(generateDepthString(depth) + node.e + "\n");
        generateBSTString(node.left, depth + 1, res);  // 遍历左子树
        generateBSTString(node.right, depth + 1, res); // 遍历右子树
    }

    /**
     * 返回代表“深度”的字符串
     * @param depth 深度
     * @return
     */
    private String generateDepthString(int depth){
        StringBuilder res = new StringBuilder();
        for(int i = 0 ; i < depth ; i ++)
            res.append("--");
        return res.toString();
    }
}
