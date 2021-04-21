package design.pattern.structural.proxy.imooic.dynamicproxy.order.service;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;

/**
 * Created by geely
 */
public interface IOrderService {
    int saveOrder(Order order);
}
