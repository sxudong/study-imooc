package design.pattern.behavioral.visitor;

/**
 * 免费课程
 */
public class FreeCourse extends Course{

    /**
     * 定义访问者
     * 这里面可以做一些权限判断，也可以在外面实现
     */
    @Override
    public void accept(IVisitor visitor) {
        // 课程对象把自已作为一个参数调用访问者visit()方法
        visitor.visit(this);
    }
}
