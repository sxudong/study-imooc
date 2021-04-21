package design.pattern.behavioral.chainofresponsibility.example.v3;

public class HandlerB extends Handler {

    @Override
    protected void doHandle() {
        //...
        System.out.println("执行 HandlerB");
    }
}