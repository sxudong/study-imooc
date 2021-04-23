package chap7.SetAndMap.example9.LeetcodeProblemsAboutMapAndSet;
/// Leetcode 350. Intersection of Two Arrays II
/// https://leetcode.com/problems/intersection-of-two-arrays-ii/description/

import java.util.ArrayList;

/**
 * 7-9 Leetcode上更多集合和映射的问题
 * <p>
 * 给定两个数组，编写一个函数来计算它们的交集。
 * <p>
 * 示例 1:
 * <p>
 * 输入: nums1 = [1,2,2,1], nums2 = [2,2]
 * 输出: [2,2]
 * 示例 2:
 * <p>
 * 输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
 * 输出: [4,9]
 * 说明：
 * <p>
 * 输出结果中每个元素出现的次数，应与元素在两个数组中出现的次数一致。
 * 我们可以不考虑输出结果的顺序。
 * 进阶:
 * <p>
 * 如果给定的数组已经排好序呢？你将如何优化你的算法？
 * 如果 nums1 的大小比 nums2 小很多，哪种方法更优？
 * 如果 nums2 的元素存储在磁盘上，磁盘内存是有限的，并且你不能一次加载所有的元素到内存中，你该怎么办？
 * <p>
 * 来源：力扣（LeetCode）
 * 链接：https://leetcode-cn.com/problems/intersection-of-two-arrays-ii
 */
public class BSTMapSolution350 {

    private interface Map<K, V> {

        void add(K key, V value);

        boolean contains(K key);

        V get(K key);

        void set(K key, V newValue);

        V remove(K key);

        int getSize();

        boolean isEmpty();
    }

    private class BSTMap<K extends Comparable<K>, V> implements Map<K, V> {

        private class Node {
            public K key;
            public V value;
            public Node left, right;

            public Node(K key, V value) {
                this.key = key;
                this.value = value;
                left = null;
                right = null;
            }
        }

        private Node root;
        private int size;

        public BSTMap() {
            root = null;
            size = 0;
        }

        @Override
        public int getSize() {
            return size;
        }

        @Override
        public boolean isEmpty() {
            return size == 0;
        }

        // 向二分搜索树中添加新的元素(key, value)
        @Override
        public void add(K key, V value) {
            root = add(root, key, value);
        }

        // 向以node为根的二分搜索树中插入元素(key, value)，递归算法
        // 返回插入新节点后二分搜索树的根
        private Node add(Node node, K key, V value) {

            if (node == null) {
                size++;
                return new Node(key, value);
            }

            if (key.compareTo(node.key) < 0)
                node.left = add(node.left, key, value);
            else if (key.compareTo(node.key) > 0)
                node.right = add(node.right, key, value);
            else // key.compareTo(node.key) == 0
                node.value = value;

            return node;
        }

        // 返回以node为根节点的二分搜索树中，key所在的节点
        private Node getNode(Node node, K key) {

            if (node == null)
                return null;

            if (key.equals(node.key))
                return node;
            else if (key.compareTo(node.key) < 0)
                return getNode(node.left, key);
            else // if(key.compareTo(node.key) > 0)
                return getNode(node.right, key);
        }

        @Override
        public boolean contains(K key) {
            return getNode(root, key) != null;
        }

        @Override
        public V get(K key) {

            Node node = getNode(root, key);
            return node == null ? null : node.value;
        }

        @Override
        public void set(K key, V newValue) {
            Node node = getNode(root, key);
            if (node == null)
                throw new IllegalArgumentException(key + " doesn't exist!");

            node.value = newValue;
        }

        // 返回以node为根的二分搜索树的最小值所在的节点
        private Node minimum(Node node) {
            if (node.left == null)
                return node;
            return minimum(node.left);
        }

        // 删除掉以node为根的二分搜索树中的最小节点
        // 返回删除节点后新的二分搜索树的根
        private Node removeMin(Node node) {

            if (node.left == null) {
                Node rightNode = node.right;
                node.right = null;
                size--;
                return rightNode;
            }

            node.left = removeMin(node.left);
            return node;
        }

        // 从二分搜索树中删除键为key的节点
        @Override
        public V remove(K key) {

            Node node = getNode(root, key);
            if (node != null) {
                root = remove(root, key);
                return node.value;
            }
            return null;
        }

        private Node remove(Node node, K key) {

            if (node == null)
                return null;

            if (key.compareTo(node.key) < 0) {
                node.left = remove(node.left, key);
                return node;
            } else if (key.compareTo(node.key) > 0) {
                node.right = remove(node.right, key);
                return node;
            } else {   // key.compareTo(node.key) == 0

                // 待删除节点左子树为空的情况
                if (node.left == null) {
                    Node rightNode = node.right;
                    node.right = null;
                    size--;
                    return rightNode;
                }

                // 待删除节点右子树为空的情况
                if (node.right == null) {
                    Node leftNode = node.left;
                    node.left = null;
                    size--;
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
    }

    /**
     * 输入: nums1 = [1,2,2,1], nums2 = [2,2]
     * 输出: [2,2]
     *
     * 输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
     * 输出: [4,9]
     */
    public int[] intersect(int[] nums1, int[] nums2) {

        // 使用映射记录nums1中元素出现频次
        BSTMap<Integer, Integer> map = new BSTMap<>();
        for (int num : nums1) {
            if (!map.contains(num)) // 如果不包含，新添加一个元素，频次1
                map.add(num, 1);
            else // 否则 现在的频次再加 1
                map.set(num, map.get(num) + 1);
        }

        ArrayList<Integer> res = new ArrayList<>();
        for (int num : nums2) {
            // 找到包含的元素
            if (map.contains(num)) {
                res.add(num);
                map.set(num, map.get(num) - 1);
                // 判断一下是否等于0了，等于就删掉
                if (map.get(num) == 0)
                    map.remove(num);
            }
        }

        int[] ret = new int[res.size()];
        for (int i = 0; i < res.size(); i++)
            ret[i] = res.get(i);

        return ret;
    }
}
