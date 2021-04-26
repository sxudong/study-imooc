package chap7.SetAndMap.example2.LinkedListSet;

import java.util.ArrayList;

/**
 * 7-2 基于链表的集合实现
 * @param <E>
 */
public class LinkedListSet<E> implements Set<E> {

    private LinkedList<E> list;

    public LinkedListSet(){
        list = new LinkedList<>();
    }

    @Override
    public int getSize(){
        return list.getSize();
    }

    @Override
    public boolean isEmpty(){
        return list.isEmpty();
    }

    @Override
    public void add(E e){
        if(!list.contains(e)) // 如果不包含就添加
            list.addFirst(e);
    }

    @Override
    public boolean contains(E e){
        return list.contains(e);
    }

    @Override
    public void remove(E e){
        list.removeElement(e);
    }

    /*
     * 测试前
     *    在IDEA 右上角锤子图标边的下拉菜单中找到“Edit Configurations”设置工作目录
     */
    public static void main(String[] args) {

        System.out.println("Pride and Prejudice");

        ArrayList<String> words1 = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words1)) {
            System.out.println("Total words: " + words1.size());

            /**
             * 基于链表的集合实现
             */
            LinkedListSet<String> set1 = new LinkedListSet<>();
            for (String word : words1)
                set1.add(word);
            System.out.println("Total different words: " + set1.getSize());
        }

        System.out.println();


        System.out.println("A Tale of Two Cities");

        ArrayList<String> words2 = new ArrayList<>();
        if(FileOperation.readFile("a-tale-of-two-cities.txt", words2)){
            System.out.println("Total words: " + words2.size());

            LinkedListSet<String> set2 = new LinkedListSet<>();
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