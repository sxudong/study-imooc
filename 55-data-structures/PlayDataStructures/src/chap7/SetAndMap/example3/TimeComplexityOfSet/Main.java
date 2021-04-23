package chap7.SetAndMap.example3.TimeComplexityOfSet;

import java.util.ArrayList;

/**
 * 7-3 集合类的复杂度分析
 */
public class Main {

    private static double testSet(Set<String> set, String filename){

        long startTime = System.nanoTime();

        System.out.println(filename);
        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile(filename, words)) {
            System.out.println("Total words: " + words.size());

            for (String word : words)
                set.add(word);
            System.out.println("Total different words: " + set.getSize());
        }
        long endTime = System.nanoTime();

        return (endTime - startTime) / 1000000000.0;
    }

    /*
     * 测试前
     *    在IDEA 右上角锤子图标边的下拉菜单中找到“Edit Configurations”
     *    设置工作目录为“F:\07-慕课网\玩转算法系列--玩转数据结构\PlayDataStructures\src\G\SetAndMap”
     */
    public static void main(String[] args) {

        String filename = "pride-and-prejudice.txt";

        BSTSet<String> bstSet = new BSTSet<>();
        double time1 = testSet(bstSet, filename);
        System.out.println("BST Set: " + time1 + " s");

        System.out.println();

        LinkedListSet<String> linkedListSet = new LinkedListSet<>();
        double time2 = testSet(linkedListSet, filename);
        System.out.println("Linked List Set: " + time2 + " s");

    }
}
/* Output:
pride-and-prejudice.txt
Total words: 125901
Total different words: 6530
BST Set: 0.1420903 s

pride-and-prejudice.txt
Total words: 125901
Total different words: 6530
Linked List Set: 2.7040726 s
*///~