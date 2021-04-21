package design.pattern.structural.proxy.imooic.dynamicproxy;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.service.IOrderService;
import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;
import design.pattern.structural.proxy.imooic.dynamicproxy.order.service.OrderServiceImpl;

/**
 * 动态代理测试
 */
public class Test {
    public static void main(String[] args) {
        Order order = new Order();
//        order.setUserId(2);
        order.setUserId(1);

        // JDK动态代理
        IOrderService orderServiceDynamicProxy = (IOrderService) new OrderServiceDynamicProxy(new OrderServiceImpl()).bind();
        orderServiceDynamicProxy.saveOrder(order);

        System.out.println("");

        // CgLib动态代理
        OrderServiceCgLib cglib = new OrderServiceCgLib();
        IOrderService instance = (IOrderService) cglib.getInstance(new OrderServiceImpl());
        instance.saveOrder(order);
    }
}
/* Output:
动态代理 before code
动态代理分配到【db1】处理数据
Service层调用Dao层添加Order
Dao层添加Order成功
动态代理 after code

动态代理 before code
动态代理分配到【db1】处理数据
Service层调用Dao层添加Order
Dao层添加Order成功
动态代理 after code
*///~