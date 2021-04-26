package chap7.SetAndMap.example6.LinkedListMap;

import java.util.ArrayList;

/**
 * 7-6 基于链表的映射实现
 * @param <K>
 * @param <V>
 */
public class LinkedListMap<K, V> implements Map<K, V> {

    /**
     * 节点内部类
     */
    private class Node{
        public K key;
        public V value;
        public Node next;

        public Node(K key, V value, Node next){
            this.key = key;
            this.value = value;
            this.next = next;
        }

        public Node(K key, V value){
            this(key, value, null);
        }

        public Node(){
            this(null, null, null);
        }

        @Override
        public String toString(){
            return key.toString() + " : " + value.toString();
        }
    }

    private Node dummyHead; //虚拟的头指针
    private int size;       //多少个元素

    public LinkedListMap(){
        dummyHead = new Node();
        size = 0;
    }

    @Override
    public int getSize(){
        return size;
    }

    @Override
    public boolean isEmpty(){
        return size == 0;
    }

    /**
     * 辅助方法
     * @param key
     * @return 返回这个节点
     */
    private Node getNode(K key){
        Node cur = dummyHead.next;
        //遍历整个链表节点
        while(cur != null){
            if(cur.key.equals(key))
                return cur;
            cur = cur.next; // 指向下一个节点
        }
        return null;
    }

    @Override
    public boolean contains(K key){
        return getNode(key) != null;
    }

    @Override
    public V get(K key){
        Node node = getNode(key);
        return node == null ? null : node.value;
    }

    @Override
    public void add(K key, V value){
        Node node = getNode(key);
        if(node == null){
            //在链表头添加元素
            dummyHead.next = new Node(key, value, dummyHead.next);
            size ++;
        } else {
            // 更新这个值，等于用户传过来的值
            node.value = value;
        }
    }

    @Override
    public void set(K key, V newValue){
        Node node = getNode(key);
        if(node == null)
            throw new IllegalArgumentException(key + " doesn't exist!");

        node.value = newValue;
    }

    /**
     * 操作基于在"4-6 使用链表实现栈"单链表中删除元素的操作方法
     * Solution.LinkedListStack
     */
    @Override
    public V remove(K key){

        Node prev = dummyHead; // 虚拟头节点
        while(prev.next != null){
            if(prev.next.key.equals(key)) // 等于要删除的节点key
                break; // 跳出while循环
            prev = prev.next;
        }

        // 跑出while循环后，此时prev.next就是要删除的节点
        if(prev.next != null){
            Node delNode = prev.next;
            prev.next = delNode.next; //指向它的下下个节点
            delNode.next = null;
            size --;
            return delNode.value;
        }

        return null;
    }

    /*
     * 测试前
     *    在IDEA 右上角锤子图标边的下拉菜单中找到“Edit Configurations”设置工作目录
     */
    public static void main(String[] args){

        System.out.println("Pride and Prejudice");

        ArrayList<String> words = new ArrayList<>();
        if(FileOperation.readFile("pride-and-prejudice.txt", words)) {
            System.out.println("Total words: " + words.size());

            /**
             * 使用我们自已定义的 映射类
             */
            LinkedListMap<String, Integer> map = new LinkedListMap<>();
            for (String word : words) {
                if (map.contains(word))
                    map.set(word, map.get(word) + 1); // key=单词，value=频率加1
                else
                    map.add(word, 1); // 初始频率为1
            }

            System.out.println("Total different words: " + map.getSize());
            System.out.println("Frequency of PRIDE: " + map.get("pride")); //“pride”出现的词频
            System.out.println("Frequency of PREJUDICE: " + map.get("prejudice"));//"prejudice"出现的词频
        }

        System.out.println();
    }
}
/* Output:
Pride and Prejudice
Total words: 125901
Total different words: 6530
Frequency of PRIDE: 53
Frequency of PREJUDICE: 11
*///~