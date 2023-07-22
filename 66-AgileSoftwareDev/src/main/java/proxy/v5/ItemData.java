package proxy.v5;


/**
 * 程序26.21 P299
 */
public class ItemData {
    public int orderId;
    public int qty;
    public String sku = "junk";

    public ItemData() {
    }

    public ItemData(int orderId, int qty, String sku) {
        this.orderId = orderId;
        this.qty = qty;
        this.sku = sku;
    }

    @Override
    public boolean equals(Object o) {
        ItemData itemData = (ItemData) o;
        return orderId == itemData.orderId && qty == itemData.qty && sku.equals(itemData.sku);
    }

}
