package proxy.v5;

/**
 * 程序26.20 P298
 */
public class OrderProxy implements Order {
    private int orderId;

    public OrderProxy(int orderId) {
        this.orderId = orderId;
    }

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

    @Override
    public void addItem(Product p, int quantity) {
        try {
            ItemData id = new ItemData(orderId, quantity, p.getSku());
            DB.store(id);
        } catch (Exception e) {
            throw new Error(e.toString());
        }
    }

    public int getOrderId() {
        return orderId;
    }
}
