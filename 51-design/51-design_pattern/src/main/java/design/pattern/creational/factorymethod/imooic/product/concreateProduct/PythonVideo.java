package design.pattern.creational.factorymethod.imooic.product.concreateProduct;

import design.pattern.creational.factorymethod.imooic.product.Video;

/**
 * Created by geely
 */
public class PythonVideo extends Video {
    @Override
    public void produce() {
        System.out.println("录制Python课程视频");
    }
}
