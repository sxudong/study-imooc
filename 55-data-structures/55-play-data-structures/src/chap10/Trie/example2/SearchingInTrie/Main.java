package chap10.Trie.example2.SearchingInTrie;

import java.util.ArrayList;


public class Main {
    /**
     * 测试前
     *    在IDEA 右上角锤子图标边的下拉菜单中找到“Edit Configurations”设置工作目录
     *    \study-imooc\55-data-structures\55-play-data-structures\src\chap10\Trie
     */
    public static void main(String[] args) {

        System.out.println("Pride and Prejudice");

        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words)){
            //使用二分搜索树
            long startTime = System.nanoTime();

            BSTSet<String> set = new BSTSet<>();
            for(String word: words)
                set.add(word);      //添加

            for(String word: words)
                set.contains(word); //查询

            long endTime = System.nanoTime();

            double time = (endTime - startTime) / 1000000000.0; //纳秒向秒的转换

            System.out.println("Total different words: " + set.getSize());
            System.out.println("BSTSet: " + time + " s");

            // --- 使用Trie

            startTime = System.nanoTime();

            Trie trie = new Trie();
            for(String word: words)
                trie.add(word);      //添加

            for(String word: words)
                trie.contains(word); //查询

            endTime = System.nanoTime();

            time = (endTime - startTime) / 1000000000.0;

            System.out.println("Total different words: " + trie.getSize());
            System.out.println("Trie: " + time + " s");
        }
    }
}
/* Output:
Pride and Prejudice
Total different words: 6530
BSTSet: 0.0605917 s
Total different words: 6530
Trie: 0.0821332 s
*///~