package chap10.Trie.example6.TrieAndPatternMatch;
/// Leetcode 211. Add and Search Word - Data structure design
/// https://leetcode.com/problems/add-and-search-word-data-structure-design/description/

import java.util.TreeMap;

/**
 * 10-5 Trie字典树和简单的模式匹配
 *
 * 211. 添加与搜索单词 - 数据结构设计
 * 设计一个支持以下两种操作的数据结构：
 *
 * void addWord(word)
 * bool search(word)
 * search(word) 可以搜索文字或正则表达式字符串，字符串只包含字母 . 或 a-z 。 . 可以表示任何一个字母。
 *
 * 示例:
 *
 * addWord("bad")
 * addWord("dad")
 * addWord("mad")
 * search("pad") -> false
 * search("bad") -> true
 * search(".ad") -> true
 * search("b..") -> true
 *
 * 说明:
 * 你可以假设所有单词都是由小写字母 a-z 组成的。
 *
 * 链接：https://leetcode-cn.com/problems/add-and-search-word-data-structure-design/
 */
public class WordDictionary {

    private class Node {

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

    /** Initialize your data structure here. */
    public WordDictionary() {
        root = new Node();
    }

    /** Adds a word into the data structure. */
    public void addWord(String word) {

        Node cur = root;
        for(int i = 0 ; i < word.length() ; i ++){
            char c = word.charAt(i);
            if(cur.next.get(c) == null)
                cur.next.put(c, new Node());
            cur = cur.next.get(c);
        }
        cur.isWord = true;
    }

    /**
     * Returns if the word is in the data structure.
     * A word could contain the dot character '.' to
     * represent any one letter.
     */
    public boolean search(String word) {
        return match(root, word, 0);
    }

    // 初始从根开始
    private boolean match(Node node, String word, int index){

        // 1、终止条件，index己经是word的长度了，整个word已经完了。
        if(index == word.length())
            return node.isWord;

        char c = word.charAt(index);

        if(c != '.') {
            if(node.next.get(c) == null)
                return false;
            return match(node.next.get(c), word, index + 1); // 递归
        }
        // 如果 c = '.'
        else {
            // node.next所存储的是下一个字符以及它对应的节点，
            // 如：d..r  dog, deer, "d"后面下一个字符有"o"、"e"
            for(char nextChar: node.next.keySet())
                if(match(node.next.get(nextChar), word, index + 1))
                    return true;
            return false;
        }
    }
}
