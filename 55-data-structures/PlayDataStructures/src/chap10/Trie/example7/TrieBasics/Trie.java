package chap10.Trie.example7.TrieBasics;

import java.util.TreeMap;

/**
 * 10-2 Trie字典树基础
 */
public class Trie {

    private class Node{

        public boolean isWord; // 是否是一个单词
        public TreeMap<Character, Node> next; // Character 只适合英语

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

    // 向Trie中添加一个新的单词word
    public void add(String word){

        Node cur = root;
        for(int i = 0 ; i < word.length() ; i ++){
            char c = word.charAt(i);
            // 将c这个字符做为一个节点插入到 Trie 中
            if(cur.next.get(c) == null) // 是否已经有了
                cur.next.put(c, new Node());
            cur = cur.next.get(c);
        }

        if(!cur.isWord) {
            cur.isWord = true; // 新的单词
            size ++;
        }
    }
}
