package design.pattern.behavioral.chainofresponsibility.example.v1;

public class HandlerC extends Handler {
    @Override
    public void handle() {
        boolean handled = false;
        //...
        System.out.println("执行 HandlerC");
        if (!handled && successor != null) {
            // 下一个处理器的调用
            successor.handle();
        }
    }
}