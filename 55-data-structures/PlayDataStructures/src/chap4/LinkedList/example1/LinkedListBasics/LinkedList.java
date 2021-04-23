package chap4.LinkedList.example1.LinkedListBasics;

/**
 * 4-1 什么是链表
 * @param <E>
 */
public class LinkedList<E> {

    /**
     * 节点
     */
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

}
