package proxy.v3;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;


/**
 * 程序26.7 P290
 */
public class DBTest {

    @Before
    public void setUp() throws Exception {
        DB.init();
    }

    @After
    public void tearDown() throws Exception {
        DB.close();
    }

    @Test
    public void testStoreProduct() throws Exception {
        ProductData storedProduct = new ProductData();
        storedProduct.name = "MyProduct";
        storedProduct.price = 1234;
        storedProduct.sku = "999";
        DB.store(storedProduct);
        ProductData retrievedProduct = DB.getProductData("999");
        DB.deleteProductData("999");
        Assert.assertEquals(storedProduct, retrievedProduct);
    }
}
