package proxy.v5;

/**
 * 程序26.12 P294
 * 把 Product 的接口和它的实现分离。所以把 Product 更改成一个接口并且创建了实现该接口的 ProductImp 。
 * 给 ProductProxy 用的，最终代码里没有使用，因为 ProductProxy 已经具有了 ProductImp 的访问方法
 * 会返回的数据。
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
