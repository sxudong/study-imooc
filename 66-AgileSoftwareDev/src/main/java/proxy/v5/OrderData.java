package proxy.v5;

/**
 * 程序26.15 P296
 * OrderData 和 ProductData 非常相似。它是一个表示 Order 数据库表
 * 中的一行的简单数据结果。
 *
 * 不要因为使用了公共的数据成员而觉得不舒服。这本来就不是一个真实意义上的对象。
 * 它只是一个数据容器。安没有什么有意义的行业需要封装。让数据变量私有并且提供
 * 获取和设置方法完全是一种不必要的复杂化。
 */
public class OrderData {
    public String customerId;
    public int orderId;

    public OrderData() {
    }

    public OrderData(int orderId,  String customerId) {
        this.orderId = orderId;
        this.customerId = customerId;
    }
}
