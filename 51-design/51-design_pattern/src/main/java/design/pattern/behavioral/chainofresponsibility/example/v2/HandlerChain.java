package design.pattern.behavioral.chainofresponsibility.example.v2;

public class HandlerChain {
    private Handler head = null;
    private Handler tail = null;

    public void addHandler(Handler handler) {
        // 当前handler的下一个继承者为空
        handler.setNextSuccessor(null);
        if (head == null) {
            head = handler;
            tail = handler;
            return;
        }
        // 将 handler 放到尾巴节点中去
        tail.setNextSuccessor(handler);
        // 更新 tail，现在尾巴是新添加来的这个handler
        tail = handler;
    }

    public void handle() {
        if (head != null) {
            head.handle();
        }
    }
}