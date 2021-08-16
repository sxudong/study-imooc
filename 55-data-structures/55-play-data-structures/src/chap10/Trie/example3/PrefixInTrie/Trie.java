package chap10.Trie.example3.PrefixInTrie;

import java.util.TreeMap;

/**
 * 10-4 Trie字典树的前缀查询
 */
public class Trie {

    private class Node{

        public boolean isWord;
        public TreeMap<Character, Node> next;

        public Node(boolean isWord){
            this.isWord = isWord;
            next = new TreeMap<>();
        }

        public Node(){
            this(false);
        }
    }

    private Node root;
    private int size;

    public Trie(){
        root = new Node();
        size = 0;
    }

    // 获得Trie中存储的单词数量
    public int getSize(){
        return size;
    }

    /**
     * 向Trie中添加一个新的单词word
     */
    public void add(String word){

        Node cur = root;
        for(int i = 0 ; i < word.length() ; i ++){
            char c = word.charAt(i);
            if(cur.next.get(c) == null)
                cur.next.put(c, new Node());
            cur = cur.next.get(c);
        }

        if(!cur.isWord){
            cur.isWord = true;
            size ++;
        }
    }

    /**
     * 向Trie中添加一个新的单词word(递归写法接口)
     */
    public void recursionAdd(String word) {
        Node cur = root;
        add(root, word, 0);
    }

    /**
     * 递归写法调用方法实现递归添加
     *
     * @param node 传入要进行添加的节点
     * @param word 传入要进行添加的单词
     */
    private void add(Node node, String word, int index) {
        // 确定终止条件,这个终止条件在没加index这个参数时,很难确定
        // 此时一个单词已经遍历完成了,如果这个结束节点没有标记为单词,就标记为单词
        if (!node.isWord && index == word.length()) {
            node.isWord = true;
            size++;
        }

        if (word.length() > index) {
            char addLetter = word.charAt(index);
            // 判断trie的下个节点组中是否有查询的字符,如果没有,就添加
            if (node.next.get(addLetter) == null) {
                node.next.put(addLetter, new Node());
            }
            // 基于已经存在的字符进行下个字符的递归查询
            add(node.next.get(addLetter), word, index + 1);
        }
    }

    /**
     * 查询单词word是否在Trie中 (非递归写法)
     */
    public boolean contains(String word){

        Node cur = root;
        for(int i = 0 ; i < word.length() ; i ++){
            char c = word.charAt(i);
            if(cur.next.get(c) == null)
                return false;
            cur = cur.next.get(c);
        }
        return cur.isWord;
    }

    /**
     * 查询单词word中是否在Trie中接口 (递归写法)
     */
    public boolean recursionContains(String word) {
        Node cur = root;
        return contains(root, word, 0);
    }

    /**
     * 查询word中是否在Trie中递归写法
     */
    private boolean contains(Node node, String word, int index) {
        if (index == word.length()) {
            return node.isWord;
        }
        char c = word.charAt(index);
        if (node.next.get(c) == null) {
            return false;
        } else {
            return contains(node.next.get(c), word, index + 1);
        }
    }


    /**
     * 查询是否在 Trie 中有单词以 prefix 为前缀 (非递归写法)
     */
    public boolean isPrefix(String prefix){
        Node cur = root;

        for(int i = 0 ; i < prefix.length() ; i ++){
            char c = prefix.charAt(i);
            if(cur.next.get(c) == null)
                return false;
            cur = cur.next.get(c);
        }

        return true;
    }

    /**
     * 查询是否在Trie中有单词一prefix为前缀 (递归调用)
     */
    public boolean recursionIsPrefix(String prefix) {
        Node node = root;
        return recursionIsPrefix(root, prefix, 0);
    }

    /**
     * 查询是否在Trie中有单词一prefix为前缀 (递归实现)
     */
    private boolean recursionIsPrefix(Node root, String prefix, int index) {
        // 终止条件
        if (prefix.length() == index) {
            return true;
        }

        char c = prefix.charAt(index);
        if (root.next.get(c) == null) {
            return false;
        } else {
            return recursionIsPrefix(root.next.get(c), prefix, ++index);
        }
    }
}
