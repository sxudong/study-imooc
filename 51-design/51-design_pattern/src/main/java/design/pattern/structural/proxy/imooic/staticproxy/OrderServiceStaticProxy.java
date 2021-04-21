package design.pattern.structural.proxy.imooic.staticproxy;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.service.IOrderService;
import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;
import design.pattern.structural.proxy.imooic.dynamicproxy.order.service.OrderServiceImpl;
import design.pattern.structural.proxy.db.DataSourceContextHolder;

/**
 * 静态代理类
 */
public class OrderServiceStaticProxy {
    private IOrderService iOrderService;

    public int saveOrder(Order order) {
        beforeMethod(order); // 方法前执行

        iOrderService = new OrderServiceImpl();
        int result = iOrderService.saveOrder(order);

        afterMethod(); // 方法后执行
        return result;
    }

    // 方法前执行
    private void beforeMethod(Order order) {
        int userId = order.getUserId();
        int dbRouter = userId % 2;
        System.out.println("静态代理分配到【db" + dbRouter + "】处理数据");

        //todo 设置dataSource;
        DataSourceContextHolder.setDBType("db" + String.valueOf(dbRouter));
        System.out.println("静态代理 before code");
    }

    // 方法后执行
    private void afterMethod() {
        System.out.println("静态代理 after code");
    }
}
