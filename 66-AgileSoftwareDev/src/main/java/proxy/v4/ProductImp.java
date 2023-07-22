package proxy.v4;

/**
 * 程序26.12 P294
 */
public class ProductImp implements Product {
    private int itsPrice;
    private String itsName;
    private String itsSku;

    public ProductImp(String sku, String name, int price) {
        this.itsSku = sku;
        this.itsName = name;
        this.itsPrice = price;
    }

    @Override
    public int getPrice() throws Exception {
        return itsPrice;
    }

    @Override
    public String getName() throws Exception {
        return itsName;
    }

    @Override
    public String getSku() throws Exception {
        return itsSku;
    }
}
