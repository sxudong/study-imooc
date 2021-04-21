package design.pattern.creational.factorymethod.imooic.factory.concreateCreator;

import design.pattern.creational.factorymethod.imooic.product.concreateProduct.JavaVideo;
import design.pattern.creational.factorymethod.imooic.product.Video;
import design.pattern.creational.factorymethod.imooic.factory.VideoFactory;

/**
 * Created by geely
 */
public class JavaVideoFactory extends VideoFactory {
    @Override
    public Video getVideo() {
        return new JavaVideo();
    }
}
