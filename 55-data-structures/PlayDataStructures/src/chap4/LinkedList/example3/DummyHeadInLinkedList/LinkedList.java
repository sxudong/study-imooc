package chap4.LinkedList.example3.DummyHeadInLinkedList;

/**
 * 4-3 使用链表的虚拟头结点
 * @param <E>
 */
public class LinkedList<E> {

    private class Node{
        public E e;
        public Node next;

        public Node(E e, Node next){
            this.e = e;
            this.next = next;
        }

        public Node(E e){
            this(e, null);
        }

        public Node(){
            this(null, null);
        }

        @Override
        public String toString(){
            return e.toString();
        }
    }

    private Node dummyHead; //虚拟头节点
    private int size;

    public LinkedList(){
        dummyHead = new Node();
        size = 0;
    }

    // 获取链表中的元素个数
    public int getSize(){
        return size;
    }

    // 返回链表是否为空
    public boolean isEmpty(){
        return size == 0;
    }

    // 在链表的index(0-based)位置添加新的元素e
    // 在链表中不是一个常用的操作，练习用：）
    public void add(int index, E e){

        if(index < 0 || index > size)
            throw new IllegalArgumentException("Add failed. Illegal index.");

//        Node prev = head;
//        for(int i = 0 ; i < index - 1 ; i ++)

        Node prev = dummyHead; // 0这个位置的前一个节点
        // 原来是从头节点开始遍历，也就是第一个节点开始，要遍历 index-1 次
        // 现在从虚拟头开始遍历，找到要插入index的前一个节点
        for(int i = 0 ; i < index ; i ++)
            prev = prev.next;

        prev.next = new Node(e, prev.next);
        size ++;
    }

    // 在链表头添加新的元素e
    public void addFirst(E e){
        add(0, e);
    }

    // 在链表末尾添加新的元素e
    public void addLast(E e){
        add(size, e);
    }

}
