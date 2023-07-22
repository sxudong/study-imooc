package proxy.v2;

import org.junit.Assert;
import org.junit.Test;

/**
 * 程序26.3 创建订单并验证价钱计算的测试程序  P288
 * 该测试中创建一个订单并且计算出该订单的总价。
 */
public class OrderTest {
    @Test
    public void testOrderPrice() {
        Order order = new Order("Bob");
        Product toothpaste = new Product("Toothpaste", 129);
        order.addItem(toothpaste, 1);
        Assert.assertEquals(129, order.total());
        Product mouthwash = new Product("Mouthwash", 342);
        order.addItem(mouthwash, 2);
        Assert.assertEquals(813, order.total()); // 342 * 2 + 129
    }
}
