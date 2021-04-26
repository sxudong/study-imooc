package chap3.StacksAndQueues.example1.ArrayStack;

public class Main {
    public static void main(String[] args) {
        ArrayStack<Integer> stack = new ArrayStack<>();

        //入栈 5 次
        for(int i = 0 ; i < 5 ; i ++){
            stack.push(i);
            System.out.println(stack);
        }
        //出栈 1 次
        stack.pop();
        System.out.println(stack);
    }
}
/* Output:
Stack: [0] top
Stack: [0, 1] top
Stack: [0, 1, 2] top
Stack: [0, 1, 2, 3] top
Stack: [0, 1, 2, 3, 4] top
Stack: [0, 1, 2, 3] top
*///~