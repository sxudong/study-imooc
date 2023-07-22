package proxy.v5;

/**
 * 程序26.18 P297
 */
public interface Order {
    String getCustomerId();
    void addItem(Product p, int quantity);
    int total();
}
