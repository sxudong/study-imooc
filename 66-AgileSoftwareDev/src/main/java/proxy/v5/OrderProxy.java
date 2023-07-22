package proxy.v5;

/**
 * 程序26.20 P298
 *
 * 创建 Order 的代理。每个 Order 实例都包含许多个 Item 实例。在关系模式（schema）
 * 中，这个关系保存在Item表中。Item 表的每一行都含有包含它的 Order 的键值。然而，在
 * 对象模型中，这个关系是用 Order 中的一个 Vector 来实现的。代理必须要以某种方法在这
 * 两种形式间进行转换。
 *
 * OrderProxy 具有和 Order 一样的行为，但是它是从数据库而不是内存中获取它的数据的。
 */
public class OrderProxy implements Order {
    private int orderId;

    public OrderProxy(int orderId) {
        this.orderId = orderId;
    }

    // 订单与产品关联,一对多
    @Override
    public int total() {
        try {
            OrderImp imp = new OrderImp(getCustomerId());
            ItemData[] itemDataArray = DB.getItemsForOrder(orderId);
            for (int i = 0; i < itemDataArray.length; i++) {
                ItemData item = itemDataArray[i];
                imp.addItem(new ProductProxy(item.sku), item.qty);
            }
            return imp.total();
        } catch (Exception e) {
            throw new Error(e.toString());
        }


    }

    @Override
    public String getCustomerId() {
        try {
            OrderData od = DB.getOrderData(orderId);
            return od.customerId;
        } catch (Exception e) {
            throw new Error(e.toString());
        }
    }

    // 把业务规则封装在 OrderImp.total 中。创建代理完全是为了分离数据库实现和业务规则。
    @Override
    public void addItem(Product p, int quantity) {
        try {
            ItemData id = new ItemData(orderId, quantity, p.getSku());
            DB.store(id); // 数据库实现
        } catch (Exception e) {
            throw new Error(e.toString());
        }
    }

    public int getOrderId() {
        return orderId;
    }
}
