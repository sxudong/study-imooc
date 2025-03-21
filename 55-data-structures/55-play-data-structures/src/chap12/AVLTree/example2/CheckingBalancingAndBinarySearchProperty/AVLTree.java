package chap12.AVLTree.example2.CheckingBalancingAndBinarySearchProperty;

import java.util.ArrayList;

/**
 * 12-3 检查二分搜索树性质和平衡性
 * 添加了两个辅助函数isBST()、isBalanced()判断是不是一个平衡二叉树？
 *
 * 对于AVLTree来说，它是对二分搜索树的改进，改进的是二分搜索树有可能退化成链表。
 * 因此引进了平衡因子这个概念。AVLTree保持每个节点左右高度差不会超过1，但是在这
 * 种情况下AVLTree同时也是一个二分搜索树，所以它也要满足二分搜索树的性质，也就是
 * 对于每一个节点来说左子树所有的节点都要小于这个节点的值。相应的右节点所有的值都要
 * 大于这个节点值，而且它的左右子树依然是二分搜索树。
 * 代码有问题的话，很有可能打破这种性质，所以设置一个函数能够让我们方便的检查我们当
 * 前的这棵AVLTree它是不是依然可以保持着它是一棵二分搜索树。
 *
 * @param <K>
 * @param <V>
 */
public class AVLTree<K extends Comparable<K>, V> {

    private class Node{
        public K key;
        public V value;
        public Node left, right;
        public int height;

        public Node(K key, V value){
            this.key = key;
            this.value = value;
            left = null;
            right = null;
            height = 1;
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
     * 判断该二叉树是否是一棵二分搜索树
     */
    public boolean isBST(){

        ArrayList<K> keys = new ArrayList<>();
        inOrder(root, keys);
        for(int i = 1 ; i < keys.size() ; i ++)
            if(keys.get(i - 1).compareTo(keys.get(i)) > 0)
                return false;
        return true;
    }

    // 中序排序
    private void inOrder(Node node, ArrayList<K> keys){

        if(node == null)
            return;

        inOrder(node.left, keys);
        keys.add(node.key);
        inOrder(node.right, keys);
    }

    /**
     * 判断该二叉树是否是一棵平衡二叉树
     */
    public boolean isBalanced(){
        return isBalanced(root);
    }

    // 判断以Node为根的二叉树是否是一棵平衡二叉树，递归算法
    private boolean isBalanced(Node node){

        if(node == null)
            return true;

        int balanceFactor = getBalanceFactor(node);
        if(Math.abs(balanceFactor) > 1)
            return false;
        // 左孩子右孩子是不是平衡二叉树
        return isBalanced(node.left) && isBalanced(node.right);
    }

    // 获得节点node的高度
    private int getHeight(Node node){
        if(node == null)
            return 0; //一个空的node，它的度度值就是0
        return node.height;
    }

    // 获得节点node的平衡因子
    private int getBalanceFactor(Node node){
        if(node == null) //节点为空，平衡因子为0
            return 0;
        //左子树的高度减去右子树的高度
        return getHeight(node.left) - getHeight(node.right);
    }

    // 向二分搜索树中添加新的元素(key, value)
    public void add(K key, V value){
        root = add(root, key, value);
    }

    // 向以node为根的二分搜索树中插入元素(key, value)，递归算法
    // 返回插入新节点后二分搜索树的根
    private Node add(Node node, K key, V value){
        //如果递归到底了，当前要添加的子树为空，此时创建一个新节点
        if(node == null){
            size ++;
            return new Node(key, value);
        }

        //如果添加的的key比当前这个节点要小的话
        if(key.compareTo(node.key) < 0)
            node.left = add(node.left, key, value);   //到左子树中添加
            //如果添加的的key比当前这个节点要大的话
        else if(key.compareTo(node.key) > 0)
            node.right = add(node.right, key, value); //到右子树中添加
            //相等的话，是更新一下value值
        else // key.compareTo(node.key) == 0
            node.value = value;

        // 添加了新的节点后，高度相应的就会有变化
        // 1.更新height
        node.height = 1 + Math.max(getHeight(node.left), getHeight(node.right));

        // 2.计算平衡因子
        int balanceFactor = getBalanceFactor(node);
        // 如果平衡因子绝对值大于1，说明整棵树不再满足平衡二叉树的条件
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

    public static void main(String[] args){
        System.out.println("Pride and Prejudice");

        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words)) {
            System.out.println("Total words: " + words.size());

            AVLTree<String, Integer> map = new AVLTree<>();
            for (String word : words) {
                if (map.contains(word))
                    map.set(word, map.get(word) + 1);
                else
                    map.add(word, 1);
            }

            System.out.println("Total different words: " + map.getSize());
            System.out.println("Frequency of PRIDE: " + map.get("pride")); //pride出现的词频
            System.out.println("Frequency of PREJUDICE: " + map.get("prejudice")); //prejudice出现的词频

            System.out.println("is BST : " + map.isBST()); //是不是一棵二分搜索树
            System.out.println("is Balanced : " + map.isBalanced()); //是否是一棵平衡二叉树
        }

        System.out.println();
    }
}
/* Output:
unbalanced : 3
unbalanced : 4
unbalanced : 7
Total different words: 6530
Frequency of PRIDE: 53
Frequency of PREJUDICE: 11
is BST : true        //是一棵二分搜索树
is Balanced : false  //不是一棵平衡二叉树
*///~