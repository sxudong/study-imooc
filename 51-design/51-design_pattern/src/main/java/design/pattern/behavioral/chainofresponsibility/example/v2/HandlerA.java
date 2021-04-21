package design.pattern.behavioral.chainofresponsibility.example.v2;

public class HandlerA extends Handler {
    @Override
    protected boolean doHandle() {
        // 如果处理器链上的某个处理器能够处理这个请求，返回true那就不会继续往下传递请求。
        boolean handled = false;
        //...
        System.out.println("执行 HandlerA");
        return handled;
    }
}