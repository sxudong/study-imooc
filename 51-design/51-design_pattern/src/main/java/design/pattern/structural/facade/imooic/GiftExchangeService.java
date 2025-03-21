package design.pattern.structural.facade.imooic;

import design.pattern.structural.facade.imooic.subsystem.PointsPaymentService;
import design.pattern.structural.facade.imooic.subsystem.QualifyService;
import design.pattern.structural.facade.imooic.subsystem.ShippingService;

/**
 * 积分交易
 */
public class GiftExchangeService {
    private QualifyService qualifyService = new QualifyService();
    private PointsPaymentService pointsPaymentService = new PointsPaymentService();
    private ShippingService shippingService = new ShippingService();

    public void giftExchange(PointsGift pointsGift) {
        if (qualifyService.isAvailable(pointsGift)) {
            //资格校验通过
            if (pointsPaymentService.pay(pointsGift)) {
                //如果支付积分成功
                String shippingOrderNo = shippingService.shipGift(pointsGift);
                System.out.println("物流系统下单成功,订单号是:" + shippingOrderNo);
            }
        }
    }
}
