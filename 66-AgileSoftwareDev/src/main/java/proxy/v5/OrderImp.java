package proxy.v5;

import java.util.Vector;

/**
 * 程序26.19 P297
 * 给 OrderProxy 使用
 * 和 Product 一样，我们需要把 Order 的接口和实现分开。所以 Order 变成了接口，
 * 而 OrderImp 变成了实现。OrderImp 对于数据库没有任何依赖。
 *
 * 必须向 OrderImp 中增加一些异常处理，因为 Product 接口会抛出异常。
 */
public class OrderImp implements Order {
    private Vector itsItems = new Vector();
    private String itsCustomerId;

    public OrderImp(String custId) {
        this.itsCustomerId = custId;
    }

    @Override
    public String getCustomerId() {
        return itsCustomerId;
    }

    @Override
    public void addItem(Product p, int qty) {
        Item item = new Item(p, qty);
        itsItems.add(item); // 放到内存中
    }

    // 把业务规则封装在 OrderImp.total 中。创建代理 OrderProxy 完全是为了分离数据库实现和业务规则。
    @Override
    public int total() {
        try {
            int total = 0;
            for (int i = 0; i < itsItems.size(); i++) {
                Item item = (Item) itsItems.elementAt(i);
                Product p = item.getProduct();
                int qty = item.getQuantity();
                total += p.getPrice() * qty;
            }
            return total;
        } catch (Exception e) {
            // 我对这些异常感到沮丧。接口背后的代理实现不应该对接口造成影响，但是代理抛出的异常却通过接口传播出去。
            // 所以我决定把所有的 Exception 改为 Errors，这样我就不必用 throws 子句来污染接口，必不必用
            // try/catch 块来这些接口的使用者。
            throw new Error(e.toString());
        }
        /*
           Throwable：有两个重要的子类：Exception（异常）和 Error（错误），二者都是 Java 异常处理的重要子类，各自都包含大量子类。
           异常和错误的区别是：异常能被程序本身可以处理，错误是无法处理。
         */
    }
}
