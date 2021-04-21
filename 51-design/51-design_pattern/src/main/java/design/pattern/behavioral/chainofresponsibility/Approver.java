package design.pattern.behavioral.chainofresponsibility;

/**
 * 批准者
 */
public abstract class Approver {
    // 责任链的核心就是在类里面包含了一个自己同样类型的一个对象
    protected Approver approver;

    // 设置下一个审批者
    public void setNextApprover(Approver approver) {
        this.approver = approver;
    }

    // 发布课程
    public abstract void deploy(Course course);
}
