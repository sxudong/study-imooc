package design.pattern.behavioral.chainofresponsibility;

/**
 * 25-2 责任链模式coding
 *
 * javax.servlet.Filter 里的 doFilter()
 */
public class Test {
    public static void main(String[] args) {
        Approver articleApprover = new ArticleApprover();
        Approver videoApprover = new VideoApprover();

        Course course = new Course();
        course.setName("Java设计模式精讲 —— By Geely");
        course.setArticle("Java设计模式精讲的手记");
        course.setVideo("Java设计模式精讲的视频");

        /** 先通过手记的审核才交给视频的审核，视频的审核过了才能进行发布上线 */
        articleApprover.setNextApprover(videoApprover);
        articleApprover.deploy(course); 
    }
}
/* Output:
Java设计模式精讲 —— By Geely含有手记，批准
Java设计模式精讲 —— By Geely含有视频，批准
*///~