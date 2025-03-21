package chap4.LinkedList.example7.ImplementQueueInLinkedList;

public class LinkedListQueue<E> implements Queue<E> {

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

    private Node head, tail;
    private int size;

    public LinkedListQueue(){
        head = null;
        tail = null;
        size = 0;
    }

    /**
     * 有多少个元素
     * @return
     */
    @Override
    public int getSize(){
        return size;
    }

    @Override
    public boolean isEmpty(){
        return size == 0;
    }

    /**
     * 加入一个元素
     * @param e
     */
    @Override
    public void enqueue(E e){
        if(tail == null){
            tail = new Node(e);
            head = tail;
        }
        else{
            tail.next = new Node(e);
            tail = tail.next;
        }
        size ++;
    }

    /**
     * 取出一个元素
     * @return
     */
    @Override
    public E dequeue(){
        if(isEmpty())
            throw new IllegalArgumentException("Cannot dequeue from an empty queue.");

        Node retNode = head;
        head = head.next;
        retNode.next = null;
        if(head == null)
            tail = null;
        size --;
        return retNode.e;
    }

    /**
     * 看一下“队首”的元素是谁
     * @return
     */
    @Override
    public E getFront(){
        if(isEmpty())
            throw new IllegalArgumentException("Queue is empty.");
        return head.e;
    }

    @Override
    public String toString(){
        StringBuilder res = new StringBuilder();
        res.append("Queue: front ");

        Node cur = head;
        while(cur != null) {
            res.append(cur + "->");
            cur = cur.next;
        }
        res.append("NULL tail");
        return res.toString();
    }

    public static void main(String[] args){

        LinkedListQueue<Integer> queue = new LinkedListQueue<>();
        for(int i = 0 ; i < 10 ; i ++){
            queue.enqueue(i);
            System.out.println(queue);

            if(i % 3 == 2){
                queue.dequeue();
                System.out.println(queue);
            }
        }
    }
}
/* Output:
Queue: front 0->NULL tail
Queue: front 0->1->NULL tail
Queue: front 0->1->2->NULL tail
Queue: front 1->2->NULL tail
Queue: front 1->2->3->NULL tail
Queue: front 1->2->3->4->NULL tail
Queue: front 1->2->3->4->5->NULL tail
Queue: front 2->3->4->5->NULL tail
Queue: front 2->3->4->5->6->NULL tail
Queue: front 2->3->4->5->6->7->NULL tail
Queue: front 2->3->4->5->6->7->8->NULL tail
Queue: front 3->4->5->6->7->8->NULL tail
Queue: front 3->4->5->6->7->8->9->NULL tail
*///~