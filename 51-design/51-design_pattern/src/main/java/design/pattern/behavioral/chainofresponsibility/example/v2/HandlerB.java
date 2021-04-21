package design.pattern.behavioral.chainofresponsibility.example.v2;

public class HandlerB extends Handler {
    @Override
    protected boolean doHandle() {
        boolean handled = false;
        //...
        System.out.println("执行 HandlerB");
        return handled;
    }
}