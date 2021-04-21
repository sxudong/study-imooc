package design.pattern.structural.proxy.imooic.dynamicproxy.order.dao;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;

/**
 * Created by geely
 */
public interface IOrderDao {
    int insert(Order order);
}
