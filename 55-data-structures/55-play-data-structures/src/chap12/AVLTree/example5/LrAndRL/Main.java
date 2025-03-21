package chap12.AVLTree.example5.LrAndRL;

import java.util.ArrayList;
import java.util.Collections;

public class Main {

    public static void main(String[] args) {
        System.out.println("Pride and Prejudice");

        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words)) {
            System.out.println("Total words: " + words.size());

            // 测试最坏的情况，放到Collections进行一次排序就好了。是按顺序放进去的，相应的BST就会退化成链表。
            Collections.sort(words);

            // Test BST
            long startTime = System.nanoTime();

            BST<String, Integer> bst = new BST<>();
            for (String word : words) {
                if (bst.contains(word))
                    bst.set(word, bst.get(word) + 1);
                else
                    bst.add(word, 1);
            }

            for(String word: words)
                bst.contains(word);

            long endTime = System.nanoTime();

            double time = (endTime - startTime) / 1000000000.0;
            System.out.println("BST: " + time + " s");


            // Test AVL Tree
            startTime = System.nanoTime();

            AVLTree<String, Integer> avl = new AVLTree<>();
            for (String word : words) {
                if (avl.contains(word))
                    avl.set(word, avl.get(word) + 1);
                else
                    avl.add(word, 1);
            }

            for(String word: words)
                avl.contains(word);

            endTime = System.nanoTime();

            time = (endTime - startTime) / 1000000000.0;
            System.out.println("AVL: " + time + " s");
        }

        System.out.println();
    }
}
/* Output: 《傲慢与偏见》这本书没有达到最坏的情况，这里是随机的。
Pride and Prejudice
Total words: 125901
BST: 0.133862 s
AVL: 0.123231 s

# 测试最坏的情况，放到Collections进行一次排序就好了。是按顺序放进去的，相应的BST就会退化成链表。
# AVLTree有自平衡机制，不会退化成链表。
Pride and Prejudice
Total words: 125901
BST: 16.5560147 s
AVL: 0.0697917 s
*///~