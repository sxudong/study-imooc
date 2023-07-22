package proxy.v4;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * 程序26.10 P293
 */
public class ProxyTest {

    @Before
    public void setUp() throws Exception {
        DB.init();
        ProductData pd = new ProductData();
        pd.sku = "ProxyTest1";
        pd.name = "ProxyTestName";
        pd.price = 456;
        DB.store(pd);
    }

    @After
    public void tearDown() throws Exception {
        DB.close();
    }

    @Test
    public void testProxyProduct() throws Exception {
        ProductProxy p = new ProductProxy("ProxyTest1");
        Assert.assertEquals(456, p.getPrice());
        Assert.assertEquals("ProxyTestName", p.getName());
        Assert.assertEquals("ProxyTest1", p.getSku());
    }
}
