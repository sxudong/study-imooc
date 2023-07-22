package proxy.v5;

/**
 * 程序26.13 P294
 * 请注意，程序26.13 中 ProductProxy 的 getSku 方法在这个问题上更进了一步。
 * 它根本没有从数据库中获取 sku。它为何可以这样做呢？因为它已经具有了 sku。
 */
public class ProductProxy implements Product {

    private String itsSku;

    public ProductProxy(String sku) {
        itsSku = sku;
    }

    @Override
    public int getPrice() throws Exception {
        ProductData pd = DB.getProductData(itsSku);
        // ProductImp 的创建对于程序员和计算机资源来说完全是一种浪费。
        // ProductProxy已经具有了ProductImp的访问方法会返回的数据。
        // 所以创建ProductImp，然后再委托给它的做法是没有必要的。
        // 这也是另外一个代码是可以引导你偏离你所期望的模式和模型的例子。
//        ProductImp p = new ProductImp(pd.sku, pd.name, pd.price);
//        return p.getPrice();
        return pd.price;
    }

    @Override
    public String getName() throws Exception {
        ProductData pd = DB.getProductData(itsSku);
        return pd.name;
    }

    @Override
    public String getSku() throws Exception {
        return itsSku;
    }
}
