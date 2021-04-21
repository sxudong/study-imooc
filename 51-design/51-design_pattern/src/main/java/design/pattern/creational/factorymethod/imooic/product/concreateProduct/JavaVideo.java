package design.pattern.creational.factorymethod.imooic.product.concreateProduct;

import design.pattern.creational.factorymethod.imooic.product.Video;

/**
 * Created by geely
 */
public class JavaVideo extends Video {
    @Override
    public void produce() {
        System.out.println("录制Java课程视频");
    }
}
