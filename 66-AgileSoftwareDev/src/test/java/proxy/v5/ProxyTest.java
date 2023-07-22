package proxy.v5;

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

    @Test
    public void testOrderKeyGeneration() throws Exception {
        OrderData o1 = DB.newOrder("Bob");
        OrderData o2 = DB.newOrder("Bill");
        int firstOrderId = o1.orderId;
        int secondOrderId = o2.orderId;
        Assert.assertEquals(firstOrderId + 1, secondOrderId);
    }

    @Test
    public void testOrderProxyTotal() throws Exception {
        DB.store(new ProductData("Wheaties", 349, "wheaties"));
        DB.store(new ProductData("Crest", 258, "crest"));
        ProductProxy wheaties = new ProductProxy("wheaties");
        ProductProxy crest = new ProductProxy("crest");
        OrderData od = DB.newOrder("testOrderProxy");
        OrderProxy order = new OrderProxy(od.orderId);
        order.addItem(crest, 1);
        order.addItem(wheaties, 2);
        Assert.assertEquals(956, order.total());
    }
}
