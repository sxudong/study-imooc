package design.pattern.structural.facade.imooic.subsystem;

import design.pattern.structural.facade.imooic.PointsGift;

/**
 * 物流子系统
 */
public class ShippingService {
    public String shipGift(PointsGift pointsGift) {
        // 物流系统的对接逻辑
        System.out.println(pointsGift.getName() + "进入物流系统");
        String shippingOrderNo = "666";
        return shippingOrderNo; // 返回物流订单号
    }
}
