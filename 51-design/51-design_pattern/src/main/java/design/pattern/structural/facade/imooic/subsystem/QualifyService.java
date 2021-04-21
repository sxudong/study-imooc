package design.pattern.structural.facade.imooic.subsystem;

import design.pattern.structural.facade.imooic.PointsGift;

/**
 * 资格服务子系统
 */
public class QualifyService {
    // 是否有资格
    public boolean isAvailable(PointsGift pointsGift) {
        System.out.println("校验" + pointsGift.getName() + " 积分资格通过,库存通过");
        return true;
    }
}