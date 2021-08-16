package chap10.Trie.example2.SearchingInTrie;

import java.util.ArrayList;


public class Main {
    /**
     * ����ǰ
     *    ��IDEA ���ϽǴ���ͼ��ߵ������˵����ҵ���Edit Configurations�����ù���Ŀ¼
     *    \study-imooc\55-data-structures\55-play-data-structures\src\chap10\Trie
     */
    public static void main(String[] args) {

        System.out.println("Pride and Prejudice");

        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words)){
            //ʹ�ö���������
            long startTime = System.nanoTime();

            BSTSet<String> set = new BSTSet<>();
            for(String word: words)
                set.add(word);      //���

            for(String word: words)
                set.contains(word); //��ѯ

            long endTime = System.nanoTime();

            double time = (endTime - startTime) / 1000000000.0; //���������ת��

            System.out.println("Total different words: " + set.getSize());
            System.out.println("BSTSet: " + time + " s");

            // --- ʹ��Trie

            startTime = System.nanoTime();

            Trie trie = new Trie();
            for(String word: words)
                trie.add(word);      //���

            for(String word: words)
                trie.contains(word); //��ѯ

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