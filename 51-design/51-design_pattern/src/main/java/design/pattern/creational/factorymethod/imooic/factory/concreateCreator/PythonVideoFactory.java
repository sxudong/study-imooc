package design.pattern.creational.factorymethod.imooic.factory.concreateCreator;

import design.pattern.creational.factorymethod.imooic.product.concreateProduct.PythonVideo;
import design.pattern.creational.factorymethod.imooic.product.Video;
import design.pattern.creational.factorymethod.imooic.factory.VideoFactory;

/**
 * Created by geely
 */
public class PythonVideoFactory extends VideoFactory {
    @Override
    public Video getVideo() {
        return new PythonVideo();
    }
}
