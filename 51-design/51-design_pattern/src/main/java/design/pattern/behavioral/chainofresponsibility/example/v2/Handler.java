package design.pattern.behavioral.chainofresponsibility.example.v2;

public abstract class Handler {
    protected Handler successor = null;

    // 设置next继承者
    public void setNextSuccessor(Handler successor) {
        this.successor = successor;
    }

    // 修改后 handle() 不再由子类实现
    public final void handle() {
        // 如果处理器链上的某个处理器能够处理这个请求，返回true那就不会继续往下传递请求。
        boolean handled = doHandle();
        if (successor != null && !handled) {
            // 执行下一个 Handler
            successor.handle();
        }
    }

    // 子类执行完方法，返回 boolean 值
    protected abstract boolean doHandle();
}