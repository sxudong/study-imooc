package proxy.v4;

/**
 * 程序26.12 P294
 * 给 ProductProxy 用的，最终代码里没有使用。
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
