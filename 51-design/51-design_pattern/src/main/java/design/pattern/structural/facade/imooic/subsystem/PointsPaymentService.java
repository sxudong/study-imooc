package design.pattern.structural.facade.imooic.subsystem;

import design.pattern.structural.facade.imooic.PointsGift;

/**
 * 积分支付子系统
 */
public class PointsPaymentService {
    public boolean pay(PointsGift pointsGift) {
        // 扣减积分
        System.out.println("支付" + pointsGift.getName() + " 积分成功");
        return true;
    }
}