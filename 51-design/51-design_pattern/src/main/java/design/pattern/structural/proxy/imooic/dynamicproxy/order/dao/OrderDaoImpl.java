package design.pattern.structural.proxy.imooic.dynamicproxy.order.dao;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;

/**
 * Created by geely
 */
public class OrderDaoImpl implements IOrderDao {
    @Override
    public int insert(Order order) {
        System.out.println("Dao层添加Order成功");
        return 1;
    }
}
