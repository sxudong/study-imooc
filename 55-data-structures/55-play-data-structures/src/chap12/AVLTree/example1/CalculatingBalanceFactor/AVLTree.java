package chap12.AVLTree.example1.CalculatingBalanceFactor;

import java.util.ArrayList;

/**
 * 12-2 计算节点的高度和平衡因子
 *
 * 基于《7-7 基于二分搜索树的映射实现》中的二叉树实现
 * AVLTree整体的框架和二分搜索树BST是一致的。整体AVLTree就是在二分搜索树的基础上
 * 补充一些代码，其实就是添加上自简称机制使得我们原先实现的这个二分搜索树在对节点进行
 * 操作的时候可以保证副棵树是平衡的。平衡的定义就是对每一个节点左右节点高度差不超过1。
 *
 * 这个实现类目前还不是平衡二叉树，还是二分搜索树，只不过记录了一下高度和平衡因子。
 *
 * @param <K>
 * @param <V>
 */
public class AVLTree<K extends Comparable<K>, V> {

    private class Node{
        public K key;
        public V value;
        public Node left, right;
        public int height; // 高度值

        public Node(K key, V value){
            this.key = key;
            this.value = value;
            left = null;
            right = null;
            height = 1; // 初始值1
        }
    }

    private Node root;
    private int size;

    public AVLTree(){
        root = null;
        size = 0;
    }

    public int getSize(){
        return size;
    }

    public boolean isEmpty(){
        return size == 0;
    }

    /**
     * 获得节点 node 的高度
     * @param node 节点
     * @return 节点的高度
     */
    private int getHeight(Node node){
        if(node == null)
            return 0; //一个空的node，它的度度值就是0
        return node.height;
    }

    /**
     * 获得节点node的平衡因子
     * @param node 节点
     * @return node的平衡因子
     */
    private int getBalanceFactor(Node node){
        if(node == null)
            return 0; //节点为空，平衡因子为0
        //左子树的高度减去右子树的高度
        return getHeight(node.left) - getHeight(node.right);
    }

    // 向二分搜索树中添加新的元素(key, value)
    // 在添加节点时维护高度值
    public void add(K key, V value){
        root = add(root, key, value);
    }

    // 向以node为根的二分搜索树中插入元素(key, value)，递归算法
    // 返回插入新节点后二分搜索树的根
    private Node add(Node node, K key, V value){
        //如果递归到底了，当前要添加的子树为空，此时创建一个新节点
        if(node == null){
            size ++;
            return new Node(key, value); //添加的节点本身是叶子节点
        }

        //根据key值确认它插入的位置，是在左子树中，还是在右子树中，还是修改当前这个node的值
        //如果添加的的key比当前这个节点要小的话
        if(key.compareTo(node.key) < 0)
            node.left = add(node.left, key, value); //到左子树中添加
        //如果添加的的key比当前这个节点要大的话
        else if(key.compareTo(node.key) > 0)
            node.right = add(node.right, key, value); //到右子树中添加
        //相等的话，是更新一下value值
        else // key.compareTo(node.key) == 0
            node.value = value;

        //添加了新的节点后，高度相应的就会有变化
        /** 1.更新 height (1 + 左右子树的最大高度值) */
        node.height = 1 + Math.max(getHeight(node.left), getHeight(node.right));

        /** 2.计算平衡因子 */
        int balanceFactor = getBalanceFactor(node);
        //如果平衡因子绝对值大于1，说明整棵树不再满足平衡二叉树的条件
        if(Math.abs(balanceFactor) > 1)
            System.out.println("unbalanced : " + balanceFactor);

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

    //工作目录 \study-imooc\55-data-structures\55-play-data-structures\src\chap12\AVLTree
    public static void main(String[] args){
        System.out.println("Pride and Prejudice");

        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words)) {
            System.out.println("Total words: " + words.size());

            //这个实现类目前还不是平衡二叉树，还是二分搜索树，只不过记录了一下高度和平衡因子。
            AVLTree<String, Integer> map = new AVLTree<>();
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
/* Output: 从输出的平衡因子可以看出是有很大的不平衡的
unbalanced : -11
unbalanced : -2
unbalanced : 8
unbalanced : 18
unbalanced : 4
unbalanced : 7
Total different words: 6530
Frequency of PRIDE: 53
Frequency of PREJUDICE: 11
*///~