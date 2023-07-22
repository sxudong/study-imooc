package proxy.v2;

/**
 * 程序26.5 P288
 */
public class Product {
    private int itsPrice;

    public Product(String name, int price) {
        itsPrice = price;
    }

    public int getPrice() {
        return itsPrice;
    }
}
