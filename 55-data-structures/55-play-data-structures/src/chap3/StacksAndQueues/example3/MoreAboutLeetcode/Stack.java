package chap3.StacksAndQueues.example3.MoreAboutLeetcode;

public interface Stack<E> {

    int getSize();     // 查看栈里有多少元素
    boolean isEmpty(); // 是否为空
    void push(E e);    // 入栈
    E pop();           // 出栈，拿出栈顶元素
    E peek();          // 查看栈顶元素是谁
}
