package design.pattern.behavioral.chainofresponsibility.example.v1;

public class HandlerB extends Handler {
    @Override
    public void handle() {
        boolean handled = false;
        //...
        System.out.println("执行 HandlerB");
        if (!handled && successor != null) {
            // 下一个处理器的调用
            successor.handle();
        }
    }
}