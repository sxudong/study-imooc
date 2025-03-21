package design.pattern.creational.abstractfactory;

/**
 * Created by geely
 */
public class Test {
    public static void main(String[] args) {
        CourseFactory courseFactory = new JavaCourseFactory();
        Video video = courseFactory.getVideo();
        Article article = courseFactory.getArticle();
        video.produce();
        article.produce();
    }
} /* Output:
录制Java课程视频
编写Java课程手记
*///~
