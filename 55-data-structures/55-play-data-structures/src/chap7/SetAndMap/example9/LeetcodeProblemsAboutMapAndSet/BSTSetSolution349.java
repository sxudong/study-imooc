package chap7.SetAndMap.example9.LeetcodeProblemsAboutMapAndSet;
/// Leetcode 349. Intersection of Two Arrays
/// https://leetcode.com/problems/intersection-of-two-arrays/description/

import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;
import java.util.ArrayList;

/**
 * 7-9 Leetcode上更多集合和映射的问题
 *
 * 349. 两个数组的交集
 *
 * 给定两个数组，编写一个函数来计算它们的交集。
 *
 * 示例 1:
 *
 * 输入: nums1 = [1,2,2,1], nums2 = [2,2]
 * 输出: [2]
 * 示例 2:
 *
 * 输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
 * 输出: [9,4]
 *
 * 说明:
 * 输出结果中的每个元素一定是唯一的。
 * 我们可以不考虑输出结果的顺序。
 *
 * 链接：https://leetcode-cn.com/problems/intersection-of-two-arrays
 */
public class BSTSetSolution349 {

    private class BST<E extends Comparable<E>> {

        private class Node{
            public E e;
            public Node left, right;

            public Node(E e){
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

        // 前序遍历以node为根的二分搜索树, 递归算法
        private void preOrder(Node node){

            if(node == null)
                return;

            System.out.println(node.e);
            preOrder(node.left);
            preOrder(node.right);
        }

        // 二分搜索树的非递归前序遍历
        public void preOrderNR(){

            Stack<Node> stack = new Stack<>();
            stack.push(root);
            while(!stack.isEmpty()){
                Node cur = stack.pop();
                System.out.println(cur.e);

                if(cur.right != null)
                    stack.push(cur.right);
                if(cur.left != null)
                    stack.push(cur.left);
            }
        }

        // 二分搜索树的中序遍历
        public void inOrder(){
            inOrder(root);
        }

        // 中序遍历以node为根的二分搜索树, 递归算法
        private void inOrder(Node node){

            if(node == null)
                return;

            inOrder(node.left);
            System.out.println(node.e);
            inOrder(node.right);
        }

        // 二分搜索树的后序遍历
        public void postOrder(){
            postOrder(root);
        }

        // 后序遍历以node为根的二分搜索树, 递归算法
        private void postOrder(Node node){

            if(node == null)
                return;

            postOrder(node.left);
            postOrder(node.right);
            System.out.println(node.e);
        }

        // 二分搜索树的层序遍历
        public void levelOrder(){

            Queue<Node> q = new LinkedList<>();
            q.add(root);
            while(!q.isEmpty()){
                Node cur = q.remove();
                System.out.println(cur.e);

                if(cur.left != null)
                    q.add(cur.left);
                if(cur.right != null)
                    q.add(cur.right);
            }
        }

        // 寻找二分搜索树的最小元素
        public E minimum(){
            if(size == 0)
                throw new IllegalArgumentException("BST is empty!");

            return minimum(root).e;
        }

        // 返回以node为根的二分搜索树的最小值所在的节点
        private Node minimum(Node node){
            if(node.left == null)
                return node;
            return minimum(node.left);
        }

        // 寻找二分搜索树的最大元素
        public E maximum(){
            if(size == 0)
                throw new IllegalArgumentException("BST is empty");

            return maximum(root).e;
        }

        // 返回以node为根的二分搜索树的最大值所在的节点
        private Node maximum(Node node){
            if(node.right == null)
                return node;

            return maximum(node.right);
        }

        // 从二分搜索树中删除最小值所在节点, 返回最小值
        public E removeMin(){
            E ret = minimum();
            root = removeMin(root);
            return ret;
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

        // 从二分搜索树中删除最大值所在节点
        public E removeMax(){
            E ret = maximum();
            root = removeMax(root);
            return ret;
        }

        // 删除掉以node为根的二分搜索树中的最大节点
        // 返回删除节点后新的二分搜索树的根
        private Node removeMax(Node node){

            if(node.right == null){
                Node leftNode = node.left;
                node.left = null;
                size --;
                return leftNode;
            }

            node.right = removeMax(node.right);
            return node;
        }

        // 从二分搜索树中删除元素为e的节点
        public void remove(E e){
            root = remove(root, e);
        }

        // 删除掉以node为根的二分搜索树中值为e的节点, 递归算法
        // 返回删除节点后新的二分搜索树的根
        private Node remove(Node node, E e){

            if( node == null )
                return null;

            if( e.compareTo(node.e) < 0 ){
                node.left = remove(node.left , e);
                return node;
            }
            else if(e.compareTo(node.e) > 0 ){
                node.right = remove(node.right, e);
                return node;
            }
            else{   // e.compareTo(node.e) == 0

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

        @Override
        public String toString(){
            StringBuilder res = new StringBuilder();
            generateBSTString(root, 0, res);
            return res.toString();
        }

        // 生成以node为根节点，深度为depth的描述二叉树的字符串
        private void generateBSTString(Node node, int depth, StringBuilder res){

            if(node == null){
                res.append(generateDepthString(depth) + "null\n");
                return;
            }

            res.append(generateDepthString(depth) + node.e +"\n");
            generateBSTString(node.left, depth + 1, res);
            generateBSTString(node.right, depth + 1, res);
        }

        private String generateDepthString(int depth){
            StringBuilder res = new StringBuilder();
            for(int i = 0 ; i < depth ; i ++)
                res.append("--");
            return res.toString();
        }
    }

    private interface Set<E> {

        void add(E e);
        boolean contains(E e);
        void remove(E e);
        int getSize();
        boolean isEmpty();
    }

    private class BSTSet<E extends Comparable<E>> implements Set<E> {

        private BST<E> bst;

        public BSTSet(){
            bst = new BST<>();
        }

        @Override
        public int getSize(){
            return bst.size();
        }

        @Override
        public boolean isEmpty(){
            return bst.isEmpty();
        }

        @Override
        public void add(E e){
            bst.add(e);
        }

        @Override
        public boolean contains(E e){
            return bst.contains(e);
        }

        @Override
        public void remove(E e){
            bst.remove(e);
        }
    }

    public int[] intersection(int[] nums1, int[] nums2) {

        BSTSet<Integer> set = new BSTSet<>();
        for(int num: nums1)
            set.add(num); // 使用set去重

        ArrayList<Integer> list = new ArrayList<>();
        // 遍历nums2，看set中是否包含nums中的数值，并加入到数list中
        for(int num: nums2){
            if(set.contains(num)){
                list.add(num);
                // 如果nums2中交集，在找到后删除set中的数值，
                // 下次再遍历到nums2中同样的元素，那么在集合
                // 中就找不到了，这样就保证了求出来的交集元素
                // 每一个只有一份。
                set.remove(num);
            }
        }

        // 遍历装入到数组中返回
        int[] res = new int[list.size()];
        for(int i = 0 ; i < list.size() ; i ++)
            res[i] = list.get(i);
        return res;
    }
}
