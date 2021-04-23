package chap4.LinkedList.example4.QueryAndUpdateInLinkedList;

public class Main {

    public static void main(String[] args) {

        LinkedList<Integer> linkedList = new LinkedList<>();
        for(int i = 0 ; i < 5 ; i ++){
            linkedList.addFirst(i);
            System.out.println(linkedList);
        }

        linkedList.add(2, 666);
        System.out.println(linkedList);
    }
}
/* Output:
0->NULL
1->0->NULL
2->1->0->NULL
3->2->1->0->NULL
4->3->2->1->0->NULL
4->3->666->2->1->0->NULL
*///~