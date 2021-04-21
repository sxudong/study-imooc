package design.pattern.behavioral.chainofresponsibility.example.v1;

public abstract class Handler {
    protected Handler successor = null;

    // 设置next继承者
    public void setNextSuccessor(Handler successor) {
        this.successor = successor;
    }

    public abstract void handle();
}

