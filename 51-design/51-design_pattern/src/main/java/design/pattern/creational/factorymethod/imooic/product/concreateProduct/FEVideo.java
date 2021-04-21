package design.pattern.creational.factorymethod.imooic.product.concreateProduct;

import design.pattern.creational.factorymethod.imooic.product.Video;

/**
 * 5-2 工厂方法 coding
 */
public class FEVideo extends Video {
    @Override
    public void produce() {
        System.out.println("录制FE课程视频");
    }
}
