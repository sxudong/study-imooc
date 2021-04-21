package design.pattern.creational.simplefactory;

/**
 * 4-2 简单工厂 coding
 */
public class JavaVideo extends Video {
    @Override
    public void produce() {
        System.out.println("录制Java课程视频");
    }
}
