package design.pattern.creational.factorymethod.imooic;

import design.pattern.creational.factorymethod.imooic.factory.concreateCreator.FEVideoFactory;
import design.pattern.creational.factorymethod.imooic.factory.concreateCreator.JavaVideoFactory;
import design.pattern.creational.factorymethod.imooic.factory.concreateCreator.PythonVideoFactory;
import design.pattern.creational.factorymethod.imooic.factory.VideoFactory;
import design.pattern.creational.factorymethod.imooic.product.Video;

/**
 * 5-2 工厂方法
 *
 */
public class Client {
    public static void main(String[] args) {
        VideoFactory videoFactory = new PythonVideoFactory();
        VideoFactory videoFactory2 = new JavaVideoFactory();
        VideoFactory videoFactory3 = new FEVideoFactory();

        Video video = videoFactory.getVideo();
        video.produce();
    }
}
/* Output:
录制Python课程视频
 */