package design.pattern.structural.proxy.imooic.staticproxy;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;

/**
 * 第16章 代理模式
 */
public class Client {
    public static void main(String[] args) {
        Order order = new Order();
        order.setUserId(2);

        // 创建静态代理类对象
        OrderServiceStaticProxy orderServiceStaticProxy = new OrderServiceStaticProxy();
        orderServiceStaticProxy.saveOrder(order);
    }
}
/* Output:
静态代理分配到【db0】处理数据
静态代理 before code
Service层调用Dao层添加Order
Dao层添加Order成功
静态代理 after code
*///~