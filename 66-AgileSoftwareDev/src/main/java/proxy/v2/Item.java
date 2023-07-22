package proxy.v2;

/**
 * 程序26.6 P289
 */
public class Item {
    private Product itsProduct;
    private int itsQuantity; // 数量

    public Item(Product p, int qty) {
        itsProduct = p;
        itsQuantity = qty;
    }

    public Product getProduct() {
        return itsProduct;
    }

    public int getQuantity() {
        return itsQuantity;
    }
}
