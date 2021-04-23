package chap4.LinkedList.example6.ImplementStackInLinkedList;

/**
 * 4-6 使用链表实现栈
 */
public class LinkedListStack<E> implements Stack<E> {

    private LinkedList<E> list;

    public LinkedListStack(){
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

    /**
     * 添加元素
     * @param e
     */
    @Override
    public void push(E e){
        list.addFirst(e);
    }

    /**
     * 从栈顶取出元素
     * @return
     */
    @Override
    public E pop(){
        return list.removeFirst();
    }

    /**
     * 查看链表第一个元素
     * @return
     */
    @Override
    public E peek(){
        return list.getFirst();
    }

    @Override
    public String toString(){
        StringBuilder res = new StringBuilder();
        res.append("Stack: top ");
        res.append(list);
        return res.toString();
    }

    public static void main(String[] args) {

        LinkedListStack<Integer> stack = new LinkedListStack<>();

        for(int i = 0 ; i < 5 ; i ++){
            stack.push(i);
            System.out.println(stack);
        }

        stack.pop();
        System.out.println(stack);
    }
}
/* Output:
Stack: top 0->NULL
Stack: top 1->0->NULL
Stack: top 2->1->0->NULL
Stack: top 3->2->1->0->NULL
Stack: top 4->3->2->1->0->NULL
Stack: top 3->2->1->0->NULL
*///~