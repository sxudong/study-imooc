package chap7.SetAndMap.example1.SetBasicsAndBSTSet;

import java.util.ArrayList;

public class Main {

    /**
     * 测试前
     *    在IDEA 右上角锤子图标边的下拉菜单中找到“Edit Configurations”设置工作目录
     *    \study-imooc\55-data-structures\55-play-data-structures\src\chap7\SetAndMap
     */
    public static void main(String[] args) {

        System.out.println("Pride and Prejudice");

        ArrayList<String> words1 = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words1)) {
            System.out.println("Total words: " + words1.size());

            /**
             * 使用自定义集合 Set
             */
            BSTSet<String> set1 = new BSTSet<>();
            for (String word : words1)
                set1.add(word);
            System.out.println("Total different words: " + set1.getSize());
        }

        System.out.println();


        System.out.println("A Tale of Two Cities");

        ArrayList<String> words2 = new ArrayList<>();
        if(FileOperation.readFile("a-tale-of-two-cities.txt", words2)){
            System.out.println("Total words: " + words2.size());

            /**
             * 使用自定义集合 Set
             */
            BSTSet<String> set2 = new BSTSet<>();
            for(String word: words2)
                set2.add(word);
            System.out.println("Total different words: " + set2.getSize());
        }
    }
}
/* Output:
Pride and Prejudice
Total words: 125901
Total different words: 6530

A Tale of Two Cities
Total words: 141489
Total different words: 9944
*///~