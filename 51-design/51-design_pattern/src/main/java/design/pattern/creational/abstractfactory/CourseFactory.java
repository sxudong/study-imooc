package design.pattern.creational.abstractfactory;


/**
 * Created by geely
 */
public interface CourseFactory {
    Video getVideo();     // 视频 (产品族)
    Article getArticle(); // 手记 (产品族)
}
