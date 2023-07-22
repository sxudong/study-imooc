package proxy.v5;

import java.util.Vector;

/**
 * 程序26.19 P297
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
            throw new Error(e.toString());
        }
    }
}
