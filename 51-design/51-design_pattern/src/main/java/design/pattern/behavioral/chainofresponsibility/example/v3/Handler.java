package design.pattern.behavioral.chainofresponsibility.example.v3;

public abstract class Handler {
    protected Handler successor = null;

    // 设计继承者
    public void setNextSuccessor(Handler successor) {
        this.successor = successor;
    }

    public final void handle() {
        // 职责链模式还有一种变体，那就是请求会被所有的处理器都处理一遍，不存在中途终止的情况。
        // 调用子类方法执行，不用再返回 boolean 值做判断
        doHandle();
        if (successor != null) {
            // 执行下一个 Handler 调用
            successor.handle();
        }
    }

    // 执行方法，交由子类完成
    protected abstract void doHandle();
}