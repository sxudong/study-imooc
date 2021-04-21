package design.pattern.behavioral.chainofresponsibility.example.v1;

public class HandlerChain {
    // Handler 相当于Node节点
    private Handler head = null;
    private Handler tail = null;

    public void addHandler(Handler handler) {
        handler.setNextSuccessor(null);
        if (head == null) {
            head = handler;
            tail = handler;
            return;
        }
        // 将 handler 放到 tail 中的 handler 节点中去
        tail.setNextSuccessor(handler);
        // 更新 tail
        tail = handler;
    }

    public void handle() {
        if (head != null) {
            head.handle();
        }
    }
}