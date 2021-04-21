package design.principle.openclose;

/**
 * 3-3 开闭原则
 */
public class Test {
    public static void main(String[] args) {
        ICourse iCourse = new JavaDiscountCourse(96, "Java从零到企业级电商开发", 348d);
        JavaDiscountCourse javaCourse = (JavaDiscountCourse) iCourse;
        System.out.println("课程ID:" + javaCourse.getId() + " 课程名称:" + javaCourse.getName() + " 课程原价:" + javaCourse.getPrice() + " 课程折后价格:" + javaCourse.getDiscountPrice() + "元");
    }
}
/* Output:
课程ID:96 课程名称:Java从零到企业级电商开发 课程原价:348.0 课程折后价格:278.40000000000003元
 */