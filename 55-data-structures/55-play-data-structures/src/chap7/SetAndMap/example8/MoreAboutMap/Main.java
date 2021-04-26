package chap7.SetAndMap.example8.MoreAboutMap;

import java.util.ArrayList;

/**
 * 7-8 映射的复杂度分析和更多映射相关问题
 * 比较 二分树实现的Map VS 链表实现的Map
 */
public class Main {


    private static double testMap(Map<String, Integer> map, String filename){

        long startTime = System.nanoTime();

        System.out.println(filename);
        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile(filename, words)) {
            System.out.println("Total words: " + words.size());

            for (String word : words){
                if(map.contains(word))
                    map.set(word, map.get(word) + 1);
                else
                    map.add(word, 1);
            }

            System.out.println("Total different words: " + map.getSize());
            System.out.println("Frequency of PRIDE: " + map.get("pride"));
            System.out.println("Frequency of PREJUDICE: " + map.get("prejudice"));
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

        BSTMap<String, Integer> bstMap = new BSTMap<>();
        double time1 = testMap(bstMap, filename);
        System.out.println("BST Map: " + time1 + " s");

        System.out.println();

        LinkedListMap<String, Integer> linkedListMap = new LinkedListMap<>();
        double time2 = testMap(linkedListMap, filename);
        System.out.println("Linked List Map: " + time2 + " s");

    }
}
/* Output: 二分树实现的Map 速度远远快于 链表实现的Map
pride-and-prejudice.txt
Total words: 125901
Total different words: 6530
Frequency of PRIDE: 53
Frequency of PREJUDICE: 11
BST Map: 0.1670883 s

pride-and-prejudice.txt
Total words: 125901
Total different words: 6530
Frequency of PRIDE: 53
Frequency of PREJUDICE: 11
Linked List Map: 12.3919083 s
*///~