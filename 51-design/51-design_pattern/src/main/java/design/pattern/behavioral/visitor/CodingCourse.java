package design.pattern.behavioral.visitor;

/**
 * 实战课程
 */
public class CodingCourse extends Course{
    private int price; // 价格

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

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
