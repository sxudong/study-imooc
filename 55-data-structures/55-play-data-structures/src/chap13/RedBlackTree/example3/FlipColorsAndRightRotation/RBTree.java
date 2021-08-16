package chap13.RedBlackTree.example3.FlipColorsAndRightRotation;

import java.util.ArrayList;

/**
 * 13-6 颜色翻转 和 右旋转
 * 颜色翻转和右旋转都是辅助子过程，尚未调用，在13-7中add调用
 * @param <K>
 * @param <V>
 */
public class RBTree<K extends Comparable<K>, V> {
    private static final boolean RED = true;    //红色
    private static final boolean BLACK = false; //黑色

    private class Node{
        public K key;
        public V value;
        public Node left, right;
        public boolean color;

        public Node(K key, V value){
            this.key = key;
            this.value = value;
            left = null;
            right = null;
            // 默认创建的节点是红色,代表它要在这个红黑树中和所等价的2-3树中对应的某一个节点融合
            color = RED;
        }
    }

    private Node root;
    private int size;

    public RBTree(){
        root = null;
        size = 0;
    }

    public int getSize(){
        return size;
    }

    public boolean isEmpty(){
        return size == 0;
    }

    // 判断节点node的颜色
    private boolean isRed(Node node){
        if(node == null)
            return BLACK;
        return node.color;
    }

    /**
     * 左旋转
     *        node                     x
     *       /   \     左旋转         /  \
     *      T1   x   --------->   node   T3
     *          / \              /   \
     *         T2 T3            T1   T2
     *
     * 左旋转其实只是一个子过程，在我们的添加逻辑中还需要进行更多的后续处理。
     * 我们在左旋转的过程并不维持红黑树的性质，我们主要做的事情是通过旋转这个过程让
     * (37, 42) 这两个元素对应是 2-3树 中一个 3-节点 就好了。
     */
    private Node leftRotate(Node node){
        Node x = node.right;

        // 左旋转
        node.right = x.left;
        x.left = node;
        x.color = node.color;
        node.color = RED;

        return x;
    }

    //     node                   x
    //    /   \     右旋转       /  \
    //   x    T2   ------->   y   node
    //  / \                       /  \
    // y  T1                     T1  T2
    private Node rightRotate(Node node){

        Node x = node.left;

        // 右旋转
        node.left = x.right;
        x.right = node;

        x.color = node.color;
        node.color = RED;

        return x;
    }

    /**
     * 颜色翻转
     */
    private void flipColors(Node node) {
        node.color = RED;         //根节点要变成红色
        node.left.color = BLACK;  //左孩子变成黑色
        node.right.color = BLACK; //右孩子变成黑色
    }

    /**
     * 向红黑树中添加新的元素(key, value)
     */
    public void add(K key, V value){
        root = add(root, key, value);
        root.color = BLACK; // 最终根节点为黑色节点
    }

    /**
     * 向以node为根的红黑树中插入元素(key, value)，递归算法
     * @param node 根节点
     * @param key  键
     * @param value 值
     * @return 返回插入新节点后红黑树的根
     */
    private Node add(Node node, K key, V value){
        //递归终止条件
        if(node == null){
            size ++;
            return new Node(key, value); // 默认插入红色节点
        }

        //根据key值确认它插入的位置，是在左子树中，还是在右子树中，还是修改当前这个node的值
        if(key.compareTo(node.key) < 0)
            node.left = add(node.left, key, value);
        else if(key.compareTo(node.key) > 0)
            node.right = add(node.right, key, value);
        else // key.compareTo(node.key) == 0
            node.value = value;

        return node;
    }

    // 返回以node为根节点的二分搜索树中，key所在的节点
    private Node getNode(Node node, K key){

        if(node == null)
            return null;

        if(key.equals(node.key))
            return node;
        else if(key.compareTo(node.key) < 0)
            return getNode(node.left, key);
        else // if(key.compareTo(node.key) > 0)
            return getNode(node.right, key);
    }

    public boolean contains(K key){
        return getNode(root, key) != null;
    }

    public V get(K key){

        Node node = getNode(root, key);
        return node == null ? null : node.value;
    }

    public void set(K key, V newValue){
        Node node = getNode(root, key);
        if(node == null)
            throw new IllegalArgumentException(key + " doesn't exist!");

        node.value = newValue;
    }

    // 返回以node为根的二分搜索树的最小值所在的节点
    private Node minimum(Node node){
        if(node.left == null)
            return node;
        return minimum(node.left);
    }

    // 删除掉以node为根的二分搜索树中的最小节点
    // 返回删除节点后新的二分搜索树的根
    private Node removeMin(Node node){

        if(node.left == null){
            Node rightNode = node.right;
            node.right = null;
            size --;
            return rightNode;
        }

        node.left = removeMin(node.left);
        return node;
    }

    // 从二分搜索树中删除键为key的节点
    public V remove(K key){

        Node node = getNode(root, key);
        if(node != null){
            root = remove(root, key);
            return node.value;
        }
        return null;
    }

    private Node remove(Node node, K key){

        if( node == null )
            return null;

        if( key.compareTo(node.key) < 0 ){
            node.left = remove(node.left , key);
            return node;
        }
        else if(key.compareTo(node.key) > 0 ){
            node.right = remove(node.right, key);
            return node;
        }
        else{   // key.compareTo(node.key) == 0

            // 待删除节点左子树为空的情况
            if(node.left == null){
                Node rightNode = node.right;
                node.right = null;
                size --;
                return rightNode;
            }

            // 待删除节点右子树为空的情况
            if(node.right == null){
                Node leftNode = node.left;
                node.left = null;
                size --;
                return leftNode;
            }

            // 待删除节点左右子树均不为空的情况

            // 找到比待删除节点大的最小节点, 即待删除节点右子树的最小节点
            // 用这个节点顶替待删除节点的位置
            Node successor = minimum(node.right);
            successor.right = removeMin(node.right);
            successor.left = node.left;

            node.left = node.right = null;

            return successor;
        }
    }

    // study-imooc\55-data-structures\55-play-data-structures
    public static void main(String[] args){
        System.out.println("Pride and Prejudice");

        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words)) {
            System.out.println("Total words: " + words.size());

            RBTree<String, Integer> map = new RBTree<>();
            for (String word : words) {
                if (map.contains(word))
                    map.set(word, map.get(word) + 1);
                else
                    map.add(word, 1);
            }

            System.out.println("Total different words: " + map.getSize());
            System.out.println("Frequency of PRIDE: " + map.get("pride"));
            System.out.println("Frequency of PREJUDICE: " + map.get("prejudice"));
        }

        System.out.println();
    }
}
