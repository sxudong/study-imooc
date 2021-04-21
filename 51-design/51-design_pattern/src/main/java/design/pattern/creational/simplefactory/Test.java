package design.pattern.creational.simplefactory;

/**
 * 第4章 简单工厂
 */
public class Test {
    public static void main(String[] args) {
        VideoFactory videoFactory = new VideoFactory();
        Video video = videoFactory.getVideo("java");
        if(video == null){
            return;
        }
        video.produce();

        Video pythonVideo = videoFactory.getVideo("python");
        pythonVideo.produce();

//        VideoFactory videoFactory = new VideoFactory();
        Video JavaVideo = videoFactory.getVideo(JavaVideo.class);
        if(JavaVideo == null){
            return;
        }
        JavaVideo.produce();
    }
}
/* Output:
录制Java课程视频
录制Python课程视频
录制Java课程视频
 */