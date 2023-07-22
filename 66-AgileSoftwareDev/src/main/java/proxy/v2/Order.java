package proxy.v2;

import java.util.Vector;

/**
 * 程序26.4 P288
 *
 * 程序26.4 至 程序26.6 中展示了通过该测试的简单代码。它使用了图26.1中的简单对象模型。
 * 它根本没有考虑数据库的存在。同时它有许多方面也是不完善的。它只是正好能让测试通过的代码。
 */
public class Order {
    private Vector itsItems = new Vector();

    public Order(String cusid) {
    }

    public void addItem(Product p, int qty) {
        Item item = new Item(p, qty);
        itsItems.add(item);
    }

    public int total() {
        int total = 0;
        for (int i = 0; i < itsItems.size(); i++) {
            Item item = (Item) itsItems.elementAt(i);
            Product p = item.getProduct();
            int qty = item.getQuantity();
            total += p.getPrice() * qty;
        }
        return total;
    }
}